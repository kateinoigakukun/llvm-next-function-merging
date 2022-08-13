#!/usr/bin/env ruby

require "yaml"

class MergeRemark

  attr_reader :remark

  def initialize(remark)
    @remark = remark
  end

  def passed?
    @remark["Name"] == "Merge"
  end

  def include_func?(func)
    @remark["Args"].any? do |arg|
      arg["Function"] == func
    end
  end

  def funcs
    @remark["Args"].filter_map{ _1["Function"]}
  end

  def merged_size
    @remark["Args"].filter_map{ _1["MergedSize"]&.to_i }.first
  end

  def eql?(other)
    @remark["Name"] == other.remark["Name"] &&
      funcs == other.funcs
  end

  def hash
    @remark["Name"].hash ^ funcs.hash
  end
end

class RemarkSet
  attr_reader :remarks

  def initialize(docs)
    @remarks = Set.new docs
  end

  def self.load_file(filename)
    remarks = YAML.load_stream(File.read(filename)).each.filter_map do |remark|
      pass = remark["Pass"]
      MergeRemark.new remark if pass == "func-merging" || pass == "multiple-func-merging"
    end
    RemarkSet.new remarks
  end

  def mergedset
    RemarkSet.new(@remarks.select do |remark|
      remark.passed?
    end)
  end

  def by_func(*names)
    RemarkSet.new(@remarks.select do |remark|
      names.all? do |name|
        remark.include_func? name
      end
    end)
  end

  def subtract(other)
    RemarkSet.new @remarks.subtract(other.remarks)
  end
end

