#!/usr/bin/env ruby

require_relative "./llvm-nextfm-remark"

def size_diff_remarks(remarks1, remarks2, options = {})
  [remarks1, remarks2].each do |r|
    r.remarks.filter! do
      next false unless _1.is_a?(MergeRemark)
      next _1.funcs.size == 2 if options[:only_pair]
      next _1.is_a?(MergePassedRemark) if options[:only_passed]
      true
    end
  end
  remarks1_funcs_map = Hash.new
  remarks1.remarks.each do |remark|
    remarks1_funcs_map[remark.funcs] = remark
  end
  remarks2_funcs_map = Hash.new
  remarks2.remarks.each do |remark|
    remarks2_funcs_map[remark.funcs] = remark
  end

  intersections = remarks1_funcs_map.keys | remarks2_funcs_map.keys

  intersections.map do |funcs|
    remark1 = remarks1_funcs_map[funcs]
    remark2 = remarks2_funcs_map[funcs]
    next [remark1, remark2]
  end
end

def testcase_name(remark)
  remark.funcs.join("_") + ".ll"
end
def dump_extract_command(remark, outpath = nil)
  args = remark.funcs.map{ "--func=#{_1}" }
  unless outpath
    outpath = testcase_name(remark)
  end
  cmd = ["llvm-extract-13"] + args + ["-o", outpath, "-S"]
  cmd.join(" ")
end

def dump_sizecmp_lit_script(remark)
  mfm_args = remark.funcs.map{ "--multiple-func-merging-only=#{_1}" }.join(" ")
  fm_args = remark.funcs.map{ "--func-merging-only=#{_1}" }.join(" ")
<<EOS
; AUTOMATICALLY GENERATED BY tools/llvm-nextfm-remark/compare-mergesize.rb
;
; RUN: %opt -S --passes="multiple-func-merging" #{mfm_args} -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging" #{fm_args} -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: [[ $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o) ]]
; XFAIL: *
EOS
end

def dump_lit_testcase(remark, src_bc, test_out_dir)
  path = File.join(test_out_dir, testcase_name(remark))
  `#{dump_extract_command(remark, path)} #{src_bc}`
  test_content = dump_sizecmp_lit_script(remark) + "\n" + File.read(path)
  File.write(path, test_content)
  true
end

if __FILE__ == $0
  require "optparse"
  opt = OptionParser.new
  options = {}
  opt.banner = "Usage: #{$0} [options] <remark1> <remark2>"
  opt.on("--only-passed", "Only output test cases that are passed") do
    options[:only_passed] = true
  end
  opt.on("--only-pair", "Only output test cases of 2-merge") do
    options[:only_pair] = true
  end
  opt.parse!(ARGV)
  if ARGV.size != 2
    puts opt
    exit 1
  end
  remark1 = ARGV[0]
  remark2 = ARGV[1]
  puts "Comparing #{remark1} and #{remark2}..."
  remark_pairs = size_diff_remarks(RemarkSet.load_file(remark1), RemarkSet.load_file(remark2), options)

  remark1_wins = 0
  remark1_total_size = 0
  remark2_wins = 0
  remark2_total_size = 0

  remark_pairs.each do |remark1, remark2|
    if remark1.nil? || remark2.nil?
      win1 = remark2.nil?
    else
      next if remark1.merged_size == remark2.merged_size
      if remark1.merged_size.nil? || remark2.merged_size.nil?
        win1 = !remark1.merged_size.nil?
      else
        win1 = remark1.merged_size < remark2.merged_size
      end
    end
    winner = win1 ? "+R1" : "-R2"
    if win1
      remark1_wins += 1
    else
      remark2_wins += 1
    end
    remark1_total_size += remark1.merged_size if remark1 and remark1.merged_size
    remark2_total_size += remark2.merged_size if remark2 and remark2.merged_size
    puts "#{winner} #{remark1&.funcs || remark2&.funcs} #{remark1&.merged_size || "x"} #{remark2&.merged_size || "x"}"
  end
  puts "Remark1 (#{remark1}) wins: #{remark1_wins}"
  puts "Remark2 (#{remark2}) wins: #{remark2_wins}"

  puts "Remark1 (#{remark1}) total size: #{remark1_total_size}"
  puts "Remark2 (#{remark2}) total size: #{remark2_total_size}"
end
