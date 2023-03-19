require_relative "./llvm-nextfm-remark"

module LLVM
  class Module
    def clone
      Module.from_ptr C.clone_module(self)
    end
  end
end

class MergePassedRemark
  def demangle(name)
    @@demangle_cache ||= {}
    @@demangle_cache[name] ||= `rustfilt '#{name}'`.chomp
  end
  def is_poly?
    fst = demangle(funcs[0])
    funcs.all? { fst == demangle(_1) }
  end

  def has_reused?(n)
    funcs.count { _1.start_with?("__fm_merge_") || _1.start_with?("__msa_merge") } == n
  end
end

class Stats
  def initialize(remarks, options)
    @remarks = remarks
    @options = options
  end

  def group_by_merge_n
    @remarks.remarks.filter{_1.is_a?(MergeRemark)}.group_by { |r| r.funcs.count }
  end

  def module
    require "llvm/core"
    @module ||= LLVM::Module.parse_bitcode(@options[:source_bc])
  end

  def pruned_size(functions)
    require "tempfile"
    Tempfile.create do |f|
      cmd = ["llvm-extract-13", "--delete"]
      cmd += functions.map{ ["--func", _1] }.flatten
      cmd += ["-o", f.path, @options[:source_bc]]
      Kernel.system(*cmd, exception: true)
      f.size
    end
  end

  def original_bc_size
    @original_bc_size ||= File.size @options[:source_bc]
  end

  def potential_reductions(missed_remarks)
    require "set"
    deletings = ::Set.new
    missed_remarks.map do |remark|
      remark.funcs[1..].map do |func|
        if self.module.functions[func]
          deletings << func
        end
      end
    end
    pruned_size(deletings)
  end

  def print_effective_merges
    source_n_by_merged_name = ::Hash.new
    @remarks.remarks.filter{_1.is_a?(MergePassedRemark)}.each do |remark|
      sources = 0
      remark.funcs.each do |func|
        if source_n_by_merged_name[func]
          sources += source_n_by_merged_name[func]
          source_n_by_merged_name.delete func
        else
          sources += 1
        end
      end
      source_n_by_merged_name[remark.function] = sources
    end
    puts "Effective merges:"
    results = source_n_by_merged_name.group_by { _2 }.sort_by { _1 }.to_a
    binding.irb
    puts "Number of effectively merged functions\tNumber of merges"
    results.each do |n, merged|
      puts "#{n}\t#{merged.count}"
    end
  end

  def print
    group_by_merge_n.each do |n, remarks|
      puts "For #{n} Merge"
      puts "  Try:    #{remarks.count}"
      puts "  Missed: #{remarks.count { _1.is_a?(MergeMissedRemark) }}"
      passed = remarks.select { _1.is_a?(MergePassedRemark) }
      puts "  Passed: #{passed.count}"
      puts "    Polymorphics: #{passed.count { _1.is_poly? }}"
      puts "  Missed reasons:"
      missed = remarks.select { _1.is_a?(MergeMissedRemark) }
      reasons = missed.group_by{ _1.reason }.sort_by{ _2.count }.reverse
      max_reason_width = reasons.map{ |reason, _| reason.length }.max
      reasons.each do |reason, remarks|
        reduction = ""
        if @options[:source_bc]
          reduction += " #{1.0 * potential_reductions(remarks) / original_bc_size} % "
        end
        puts "    #{reason.ljust(max_reason_width)} : #{remarks.count}#{reduction}"
      end
      missed_by_alignments = missed.select { _1.name == "Alignment" }
      if @options[:alignments] and not missed_by_alignments.empty?
        puts "  Missed by alignment (X-th percentile):"
        shape_sizes = missed_by_alignments.map{ _1.find_arg("Shape").map(&:to_i).inject(:*) }.sort
        [0.1, 0.25, 0.5, 0.75, 0.9].map do |p|
          i = ((shape_sizes.length - 1) * p + 1).floor - 1
          v = shape_sizes[i]
          puts "    #{(p * 100).to_s.ljust(5)} : #{v}"
        end
      end
      puts ""
    end
  end
end

if __FILE__ == $0
  require "optparse"
  opt = OptionParser.new
  options = {
    mode: "stats",
  }
  opt.banner = "Usage: #{$0} [options] <remark>.."
  opt.on("-A", "--alignments", "Show alignment statistics") { options[:alignments] = true }
  opt.on("-S FILE", "--source-bc FILE", "Specify source .bc file for more analysis") do |v|
    options[:source_bc] = v
  end
  opt.on("--mode MODE", "Specify mode (default: stats)") do |v|
    options[:mode] = v
  end
  opt.parse!(ARGV)

  if ARGV.empty?
    puts opt
    exit 1
  end

  ARGV.each do |file|
    remarks = RemarkSet.load_file(file)
    stats = Stats.new(remarks, options)
    puts "Stats for #{file}"
    puts ""
    case options[:mode]
    when "stats"
      stats.print
    when "effective-merges"
      stats.print_effective_merges
    else
      raise "Unknown mode #{options[:mode]}"
    end
  end
end
