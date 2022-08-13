#!/usr/bin/env ruby

require_relative "./llvm-nextfm-remark"

def size_diff_remarks(remarks1, remarks2)
  remarks1.remarks.filter_map do |remark1|
    remark2 = remarks2.remarks.find { |r| r.funcs == remark1.funcs }
    next unless remark2
    merged_size1 = remark1.merged_size
    merged_size2 = remark2.merged_size
    next unless merged_size1 && merged_size2 && merged_size1 != merged_size2
    next [remark1, remark2]
  end
end

if __FILE__ == $0
  if ARGV.size != 2
    puts "Usage: #{$0} <remark1> <remark2>"
    exit 1
  end
  remark1 = ARGV[0]
  remark2 = ARGV[1]
  puts "Comparing #{remark1} and #{remark2}..."
  remark_pairs = size_diff_remarks(RemarkSet.load_file(remark1), RemarkSet.load_file(remark2))

  remark1_wins = 0
  remark1_total_size = 0
  remark2_wins = 0
  remark2_total_size = 0

  remark_pairs.each do |remark1, remark2|
    winner = remark1.merged_size < remark2.merged_size ? "R1" : "R2"
    if remark1.merged_size < remark2.merged_size
      remark1_wins += 1
    else
      remark2_wins += 1
    end
    remark1_total_size += remark1.merged_size
    remark2_total_size += remark2.merged_size
    puts "+#{winner} #{remark1.funcs} #{remark1.merged_size} #{remark2.merged_size}"
  end
  puts "Remark1 (#{remark1}) wins: #{remark1_wins}"
  puts "Remark1 (#{remark2}) wins: #{remark2_wins}"

  puts "Remark1 (#{remark1}) total size: #{remark1_total_size}"
  puts "Remark2 (#{remark2}) total size: #{remark2_total_size}"
end
