#!/usr/bin/env ruby
require 'elftools'

class ELFTools::Sections::Symbol
  def type
    @header.st_info & 0xf
  end
end

module Analysis
  class Core
    def initialize(elf)
      @symtab_section = elf.section_by_name('.symtab')
      @text_sec_size = elf.sections.filter{ _1.name.start_with? ".text" }.map{ _1.header.sh_size }.sum
      @func_syms = @symtab_section.symbols.select { |s| s.type == ELFTools::Constants::STT_FUNC }
      @stripped_sections = elf.sections.reject do |s|
        s.header.sh_type == ELFTools::Constants::SHT_RELA ||
          s.header.sh_type == ELFTools::Constants::SHT_REL ||
          s.header.sh_type == ELFTools::Constants::SHT_SYMTAB ||
          s.header.sh_type == ELFTools::Constants::SHT_STRTAB ||
          s.name.start_with?('.debug')
      end
    end

    def dump_heavy_syms(top = 100)
      @func_syms.sort_by{ _1.header.st_size }.reverse[..top].map do |sym|
        sym_size = sym.header.st_size
        percent = 100 * sym_size.to_f / @text_sec_size
        sprintf "%4f\t%d\t%s", percent, sym_size, sym.name
      end.join("\n")
    end
  end

  class Rust < Core
    def initialize(elf)
      super(elf)
      @mono_syms = {}
      @func_syms.each do |sym|
        @mono_syms[demangle(sym.name)] ||= []
        @mono_syms[demangle(sym.name)].push sym
      end
    end

    def demangle(name)
      @@demangle_cache ||= {}
      @@demangle_cache[name] ||= `rustfilt '#{name}'`.chomp
    end

    def dump_collecting_monos(top = 100, demangle: true)
      syms = @mono_syms.map { |k, v| [k, v, v.map{ _1.header.st_size }.sum] }
      syms.sort_by{ |_, _, total_size| total_size }.reverse[..top].map do |k, syms, total_size|
        sprintf "%d\t%d\t%04f\t%s", syms.size, total_size, 100 * total_size.to_f / @text_sec_size, demangle ? k : syms[0].name
      end.join("\n")
    end
  end
end

def main
  require "optparse"
  options = {}
  opts = OptionParser.new do |opts|
    opts.banner = "Usage: elf-inspect.rb [options] <input.elf>"
    opts.on("-h", "--help", "Show this message") do
      puts opts
      exit
    end
    opts.on("--lang LANG", "Source language")
  end
  opts.parse!(into: options)
  raise "No input file" if ARGV.empty?
  elf = ELFTools::ELFFile.new(File.open(ARGV[0]))
  if options[:lang] == "rust"
    analysis = Analysis::Rust.new(elf)
  else
    analysis = Analysis::Core.new(elf)
  end
  binding.irb
end

main if $0 == __FILE__
