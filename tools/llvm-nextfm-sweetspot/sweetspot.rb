require "fileutils"
require "json"

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "markdown"

def process_remark(remark, tmpdir, bmark_out, tool, llc)
  name = File.basename(File.dirname(remark))
  puts "Processing #{name}"
  obj_bc = File.join(File.dirname(remark), "obj.bc")
  outdir = File.join(tmpdir, name)
  FileUtils.mkdir_p(outdir) unless Dir.exist?(outdir)

  out_bc = File.join(outdir, "obj.best.bc")
  out_stats = File.join(outdir, "obj.best.stats")
  args = [tool, "--remark", remark, obj_bc, "--filetype=llvm-bc", "-o", out_bc, "--delete-stats", out_stats]
  Kernel.system(*args, exception: true)

  out_best_obj = File.join(outdir, "obj.best.o")
  args = [llc, out_bc, "-filetype=obj", "-o", out_best_obj]
  Kernel.system(*args, exception: true)

  out_base_obj = File.join(outdir, "obj.base.o")
  args = [llc, obj_bc, "-filetype=obj", "-o", out_base_obj]
  Kernel.system(*args, exception: true)

  reduction_per = (File.size(out_best_obj) - File.size(out_base_obj)) * 100 / File.size(out_base_obj)

  stats = JSON.parse(File.read(out_stats))
  puts "Done #{name}: #{File.size(out_base_obj)} -> #{File.size(out_best_obj)} (#{sprintf("%.2f", reduction_per)}%)"
  puts "Deleted functions: #{stats["DeletedFunctions"]}, Origianl functions: #{stats["OriginalFunctions"]}"

  [
    "`#{name}`",
    stats["DeletedFunctions"].to_s,
    stats["DeletedFunctions"] * 100 / stats["OriginalFunctions"],
    File.size(out_base_obj) - File.size(out_best_obj),
    reduction_per,
  ]
rescue => e
  puts "Failed to run for #{name}"
  puts e
  nil
end

if __FILE__ == $0
  bmark_out = "/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/build/bench-play/analysis/rustc-perf/plot-data/3-function-merge"
  tool = "/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/build/release-13-rustc/tools/llvm-nextfm-sweetspot/llvm-nextfm-sweetspot"
  llc = "llc-13"
  tmpdir = "/tmp/llvm-nextfm-sweetspot"
  table = Markdown::Table.new([
    ["Benchmark", :left],
    ["Deleted Functions", :right], ["Deleted Functions (%)", :right],
    ["Reduction (bytes)", :right], ["Reduction (%)", :right],
  ])
  workers = Dir.glob("#{bmark_out}/*/remarks.yaml").map do |remark|
    Thread.new do
      process_remark(remark, tmpdir, bmark_out, tool, llc)
    end
  end

  workers.each do |worker|
    row = worker.value
    table.add_row(row) if row
    puts table.to_markdown
  end
end
