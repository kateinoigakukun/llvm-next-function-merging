#!/usr/bin/env ruby
require "fileutils"
require "rake/tasklib"

class DotRecordParser
  def initialize(tokens)
    @tokens = tokens
  end

  VStack = Struct.new(:contents)
  HStack = Struct.new(:contents)
  Field = Struct.new(:id, :name)
  Text = Struct.new(:text)

  def self.tokenize(content)
    tokens = []
    while !content.empty?
      case content
      when /^\{/
        tokens << :open
        content = $'
      when /^\}/
        tokens << :close
        content = $'
      when /^\.\.\./
        tokens << :ellipsis
        content = $'
      when /^\\l/
        tokens << :newline
        content = $'
      when /^\|/
        tokens << :pipe
        content = $'
      when /^</
        tokens << :less
        content = $'
      when /^>/
        tokens << :greater
        content = $'
      when /^[^{}<>|\\]+/
        tokens << $&
        content = $'
      else
        raise "Cannot tokenize: #{content}"
      end
    end
    tokens
  end

  def parse_tokens
    while tok = @tokens.shift
      case tok
      when :open
        return parse_contents(:v)
      end
    end
  end

  def parse_contents(mode)
    contents = []
    text_contents = []
    flush = -> {
      if !text_contents.empty?
        text_contents.pop if text_contents.last == :newline
        contents << Text.new(text_contents)
        text_contents = []
      end
    }
    while tok = @tokens.shift
      case tok
      when :open
        flush.call
        contents << parse_contents(mode == :v ? :h : :v)
      when :close
        flush.call
        return mode == :v ? VStack.new(contents) : HStack.new(contents)
      when :less
        flush.call
        contents << parse_field
      when :pipe
        flush.call
      when :newline
        if @tokens.first == :ellipsis
          # Remove \l...
          @tokens.shift
        else
          text_contents << tok
          flush.call
        end
      else
        if text_contents.last.is_a?(String)
          last = text_contents.pop
          text_contents << (last + tok)
        else
          text_contents << tok
        end
      end
    end
    contents
  end

  def parse_field
    tok = @tokens.shift
    raise "Expected field id, got #{tok}" unless tok.is_a?(String)
    id = tok
    tok = @tokens.shift
    raise "Expected >, got #{tok}" unless tok == :greater
    tok = @tokens.shift
    raise "Expected field name, got #{tok}" unless tok.is_a?(String)
    name = tok
    node = Field.new(id, name)
    node
  end

  def self.parse(content)
    tokens = tokenize(content)
    parser = new(tokens)
    parser.parse_tokens
  end
end

class DotRecord2HTML
  def initialize(color, fillcolor, highlighter)
    @out = ""
    @color = color
    @fillcolor = fillcolor
    @highlighter = highlighter
    @indent = 0
  end

  def translate(node)
    line %Q(<TABLE BORDER="2" CELLBORDER="1" CELLSPACING="0" COLOR="#{@color}" BGCOLOR="#{@fillcolor}">)
    indent do
      translate_vstack(node)
    end
    line "</TABLE>"
  end

  def translate_vstack(node)
    @columns = max_cols(node)
    node.contents.each do |c|
      translate_row(c)
    end
  end

  def max_cols(vstack)
    vstack.contents.map do |c|
      case c
      when DotRecordParser::Text
        1
      when DotRecordParser::HStack
        c.contents.size
      else
        raise "Unexpected node: #{c}"
      end
    end.max
  end

  def translate_row(c)
    line "<TR>"
    indent do
      case c
      when DotRecordParser::Text
        line "<TD BALIGN=\"LEFT\" ALIGN=\"LEFT\" COLSPAN=\"#{@columns}\" BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"1\">"
        indent { translate_text(c) }
        line "</TD>"
      when DotRecordParser::HStack
        c.contents.each do |cc|
          case cc
          when DotRecordParser::Text
            line "<TD BALIGN=\"LEFT\">"
            indent { translate_text(cc) }
            line "</TD>"
          when DotRecordParser::Field
            translate_field(cc)
          else
            raise "Unexpected node: #{cc}"
          end
        end
      else
        raise "Unexpected node: #{c}"
      end
    end
    line "</TR>"
  end

  def translate_text(node)
    while tok = node.text.shift
      case tok
      when :newline
        @out << "<BR/>"
        newline
      else
        push_color_line(tok)
      end
    end
  end

  def push_color_line(line)
    line = line.gsub(/\s$/, "")
    color = @highlighter.highlight(line)
    font = "LiberationSans-Regular"
    push %Q(<FONT COLOR="#{color}" FACE="#{font}">#{line}</FONT>)
  end

  def translate_field(node)
    line "<TD PORT=\"#{node.id}\">#{node.name}</TD>"
  end

  def indent
    @indent += 1
    yield
    @indent -= 1
  end

  private
  def line(str)
    @out << "  " * @indent
    @out << str
    @out << "\n"
  end
  private
  def push(str)
    @out << str
  end
  private
  def newline
    @out << "\n"
  end
end

class CFGPainter < Rake::TaskLib
  def initialize
    @example_dir = File.expand_path(File.dirname(__FILE__))
    @repo_root = File.expand_path(File.join(@example_dir, "..", "..", ".."))
    @dot_x_dir = File.join(@repo_root, ".x")
    @build_dir = File.join(@dot_x_dir, "build", "RelWithDebInfo")
  end

  def opt
    ENV["OPT"] || File.join(@build_dir, "tools", "llvm-nextfm-opt")
  end

  def run
    input = File.join(@example_dir, "471.omnetpp.min.ll")
    mfm = apply_mfm(input)
    f3m = apply_f3m(input)
    dots_dir = File.join(@dot_x_dir, "example", "dot-cfg")
    dot_cfg(mfm, dots_dir)
    dot_cfg(f3m, dots_dir)
    dot_cfg(input, dots_dir)
    Dir.glob(File.join(dots_dir, ".*.dot")).each do |dot|
      emit_svg(patch_dot(dot))
    end
  end

  def apply_mfm(input)
    filename = File.basename(input)
    output = File.join(@dot_x_dir, "example", "#{filename}.mfm.ll") 
    FileUtils.mkdir_p File.dirname(output)
    cmd = [opt, input, "-o", output] + %w[
      -S
      --passes=multiple-func-merging
      -pass-remarks-filter=multiple-func-merging
      -func-merging-explore=2
      -multiple-func-merging-whole-program=true
      -multiple-func-merging-coalescing=false
      -multiple-func-merging-only=_ZN4cPar12setBoolValueEb
      -multiple-func-merging-only=_ZN4cPar14setDoubleValueEd
      -multiple-func-merging-only=_ZN4cPar12setLongValueEl
    ]
    sh *cmd
    output
  end

  def apply_f3m(input)
    filename = File.basename(input)
    output = File.join(@dot_x_dir, "example", "#{filename}.f3m.ll")
    FileUtils.mkdir_p File.dirname(output)
    cmd = [opt, input, "-o", output] + %w[
      -S
      --passes=func-merging
      -pass-remarks-filter=func-merging
      -func-merging-explore=2
      -func-merging-whole-program=true
      -func-merging-coalescing=false
      -func-merging-only=_ZN4cPar14setDoubleValueEd
      -func-merging-only=_ZN4cPar12setLongValueEl
    ]
    sh *cmd
    output
  end

  def dot_cfg(input, output_dir)
    cmd = [opt, input] + %w[--passes=dot-cfg -o /dev/null]
    FileUtils.mkdir_p output_dir
    sh *cmd, chdir: output_dir
  end

  class Highlighter
    def highlight(line)
      "#000000"
    end
  end

  def patch_dot(input)
    output = File.join(@dot_x_dir, "example", "dot-cfg", "patched", File.basename(input))
    FileUtils.mkdir_p File.dirname(output)
    content = File.read(input)
    puts "Patch #{input} -> #{output}"
    content.gsub!(/color="(.*)?", style=filled, fillcolor="(.*)?",label="(.*)"\]/) do |m|
      color = $1
      fillcolor = $2
      label_content = $3
      node = DotRecordParser.parse(label_content)
      "label=<" + DotRecord2HTML.new(color, fillcolor, Highlighter.new).translate(node) + ">]"
    end
    content.gsub!("shape=record", "shape=plaintext")
    File.write(output, content)
    output
  end

  def emit_svg(dot_input)
    filename = File.basename(dot_input, ".dot")
    filename = filename.start_with?(".") ? filename[1..-1] : filename
    output = File.join(@dot_x_dir, "example", "svg", "#{filename}.svg")
    FileUtils.mkdir_p File.dirname(output)
    sh "dot", "-Tsvg", dot_input, "-o", output
    output
  end
end

def main
  CFGPainter.new.run
end

main if __FILE__ == $0
