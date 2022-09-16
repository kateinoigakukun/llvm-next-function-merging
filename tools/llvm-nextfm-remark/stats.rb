require_relative "./llvm-nextfm-remark"

module LLVM
  class Module
    def clone
      Module.from_ptr C.clone_module(self)
    end
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
    deletings = Set.new
    missed_remarks.map do |remark|
      remark.funcs[1..].map do |func|
        if self.module.functions[func]
          deletings << func
        end
      end
    end
    pruned_size(deletings)
  end

  def print
    group_by_merge_n.each do |n, remarks|
      puts "For #{n} Merge"
      puts "  Try:    #{remarks.count}"
      puts "  Missed: #{remarks.count { _1.is_a?(MergeMissedRemark) }}"
      puts "  Passed: #{remarks.count { _1.is_a?(MergePassedRemark) }}"
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
  options = {}
  opt.banner = "Usage: #{$0} [options] <remark>.."
  opt.on("-A", "--alignments", "Show alignment statistics") { options[:alignments] = true }
  opt.on("-S FILE", "--source-bc FILE", "Specify source .bc file for more analysis") do |v|
    options[:source_bc] = v
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
    stats.print
  end
end
