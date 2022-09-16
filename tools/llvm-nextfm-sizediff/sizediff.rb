#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "markdown"

class SizeDiff
    def build_obj_pattern(base_path)
        File.join(base_path, "**", "obj.strip.o")
    end

    def initialize(results)
        diff = {}
        results.each do |base_path, variant|
            Dir.glob(build_obj_pattern(base_path)).each do |obj_path|
                key = obj_path.delete_prefix(base_path).delete_prefix("/")
                diff[key] ||= {}
                diff[key][variant] = File.size(obj_path)
            end
        end
        @diff = diff
    end

    def to_markdown
        columns = [
            ["Path", :left], ["Old", :right], ["New", :right], ["Diff (bytes)", :right], ["Diff (%)", :right]
        ]
        table = Markdown::Table.new(columns)
        rows = @diff.map do |path, sizes|
            old_size = sizes[:old]
            new_size = sizes[:new]
            if old_size && new_size
                diff = new_size - old_size
                per = (diff.to_f / old_size * 100).round(3)
                sign = diff.positive? ? "+" : ""
                ["`#{path}`", old_size.to_s, new_size.to_s, sign + diff.to_s, sign + per.to_s]
            elsif old_size
                ["`#{path}`", old_size.to_s, "", "", ""]
            elsif new_size
                ["`#{path}`", "", new_size.to_s, "", ""]
            end
        end
        rows.each do |row|
            table.add_row(row)
        end
        table.to_markdown
    end
end

if __FILE__ == $0
    if ARGV.size != 2
        puts "Usage: #{$0} <old> <new>"
        exit 1
    end
    old_path = ARGV[0]
    new_path = ARGV[1]
    puts SizeDiff.new([[old_path, :old], [new_path, :new]]).to_markdown
end
