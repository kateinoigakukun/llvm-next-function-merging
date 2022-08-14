require_relative "./llvm-nextfm-remark"

class Stats
  def initialize(remarks, options)
    @remarks = remarks
    @options = options
  end

  def group_by_merge_n
    @remarks.remarks.filter{_1.is_a?(MergeRemark)}.group_by { |r| r.funcs.count }
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
        puts "    #{reason.ljust(max_reason_width)} : #{remarks.count}"
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
