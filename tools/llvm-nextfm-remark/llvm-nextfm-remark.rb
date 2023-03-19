#!/usr/bin/env ruby

require "yaml"
require "set"

class Remark
  attr_reader :remark

  def initialize(remark)
    @remark = remark
  end

  def name
    @remark["Name"]
  end

  def find_arg(key)
    @remark["Args"].filter_map{ _1[key] }
  end
end

class MergeRemark < Remark
  def funcs
    @remark["Args"].filter_map{ _1["Function"]}
  end

  def merged_size
    @remark["Args"].filter_map{ _1["MergedSize"]&.to_i }.first
  end
end

class MergePassedRemark < MergeRemark

  def passed?
    @remark["Name"] == "Merge"
  end

  def include_func?(func)
    @remark["Args"].any? do |arg|
      arg["Function"] == func
    end
  end

  def eql?(other)
    @remark["Name"] == other.remark["Name"] &&
      funcs == other.funcs
  end

  def hash
    @remark["Name"].hash ^ funcs.hash
  end

  def function
    @remark["Function"]
  end
end

class MergeMissedRemark < MergeRemark;
  def reason
    r = find_arg("Reason")[0]
    return name if r.nil?
    "#{name} (#{r})"
  end
end

class MissedRemark < Remark; end

class RemarkSet
  attr_reader :remarks

  def initialize(docs)
    @remarks = ::Set.new docs
  end

  def self.load_file(filename)
    self.load(File.read(filename))
  end

  def self.load(content)
    YAML.add_domain_type("", "Passed") do |_, map|
      pass = map["Pass"]
      if pass == "func-merging" || pass == "multiple-func-merging"
        MergePassedRemark.new map
      else
        Remark.new map
      end
    end
    YAML.add_domain_type("", "Missed") do |_, map|
      pass = map["Pass"]
      if pass == "func-merging" || pass == "multiple-func-merging"
        MergeMissedRemark.new map
      else
        Remark.new map
      end
    end

    remarks = YAML.load_stream(content)
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

