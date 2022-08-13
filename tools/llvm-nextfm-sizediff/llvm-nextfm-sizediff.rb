#!/usr/bin/env ruby

class SizeDiff
    def build_obj_pattern(base_path)
        File.join(base_path, "**", "obj.o")
    end

    def initialize(old_path, new_path)
        diff = {}
        [[old_path, :old], [new_path, :new]].each do |base_path, variant|
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
        rows = [
            columns.map {|c| c[0] }
        ]
        rows += @diff.map do |path, sizes|
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

        columns_width = rows.transpose.map do |col|
            col.map(&:size).max
        end

        lines = rows.map do |row|
            "| " + row.zip(columns_width, columns).map do |cell, width, col|
                col[1] == :left ? cell.ljust(width) : cell.rjust(width)
            end.join(" | ") + " |"
        end
        separator = "| " + columns_width.map {|w| "-" * w }.join(" | ") + " |"
        ([lines[0], separator] + lines[1..]).join("\n") + "\n"
    end
end

if __FILE__ == $0
    if ARGV.size != 2
        puts "Usage: #{$0} <old> <new>"
        exit 1
    end
    old_path = ARGV[0]
    new_path = ARGV[1]
    puts SizeDiff.new(old_path, new_path).to_markdown
end
