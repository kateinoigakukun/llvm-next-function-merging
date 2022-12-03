module Markdown
  class Table
    def initialize(columns)
      @columns = columns
      @rows = [
        columns.map {|c| c[0] }
      ]
    end

    def add_row(row)
      @rows << row.map(&:to_s)
    end

    def to_markdown
      columns_width = @rows.transpose.map do |col|
        col.map(&:size).max
      end

      lines = @rows.map do |row|
        "| " + row.zip(columns_width, @columns).map do |cell, width, col|
          col[1] == :left ? cell.ljust(width) : cell.rjust(width)
        end.join(" | ") + " |"
      end
      separator = "| " + columns_width.map {|w| "-" * w }.join(" | ") + " |"
      ([lines[0], separator] + lines[1..]).join("\n") + "\n"
    end
  end
end
