require "fileutils"
require "json"
require "open3"

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "markdown"
require_relative "../llvm-nextfm-remark/llvm-nextfm-remark"

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

def find_best_merge_candidate(remark, tool, obj_bc, db)
  # skip if we already have a candidate
  func_names = remark.funcs.join(",")
  if db.execute("SELECT * FROM missed_merges WHERE func_names = ?", func_names).size > 0
    puts "\x1b[1;33m[SKIP]\x1b[m #{func_names}"
    return
  end
  require "tempfile"
  Tempfile.create("sweetspot") do |f|
    args = [tool, obj_bc, "-o", f.path]
    args += remark.funcs.map { |f| "--del-func=#{f}" }
    puts "\x1b[1;36m[RUN ]\x1b[m #{args.map{ "'#{_1}'" }.join(" ")}"
    Kernel.system(*args, exception: true)
    strip_args = ["strip", "-s", f.path]
    Kernel.system(*strip_args, exception: true)
    size = File.size(f.path)
    db.execute("INSERT INTO missed_merges (func_names, bytes) VALUES (?, ?)", [func_names, size])
    puts "\x1b[1;32m[OK  ]\x1b[m #{size}: #{func_names}"
  end

rescue => e
  puts ""
  puts "\x1b[1;31m[FAIL]\x1b[m #{func_names}"
  nil
end

def create_db_skeleton(db)
  db.execute("CREATE TABLE IF NOT EXISTS missed_merges (func_names TEXT, bytes INTEGER)")
end

FIND_PAIR = true

if __FILE__ == $0
  tool = "/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/build/release-13-rustc-llvmrel/tools/llvm-nextfm-sweetspot/llvm-nextfm-sweetspot"
  if FIND_PAIR
    require 'sqlite3'
    remark_file = ARGV[0]
    name = File.basename(File.dirname(remark_file))
    obj_bc = File.join(File.dirname(remark_file), "obj.bc")
    db = SQLite3::Database.new "test.db"
    create_db_skeleton(db)
    works = RemarkSet.load_file(remark_file).remarks.to_a.reverse.filter_map do |remark|
      next unless remark.is_a?(MergeMissedRemark)
      proc {
        find_best_merge_candidate(remark, tool, obj_bc, db)
      }
    end
    worker_count = 8
    batch_size = works.size / worker_count
    workers = works.each_slice(batch_size).to_a.map do |works|
      Thread.new {
        works.each do |work|
          work.call
        end
      }
    end
    workers.each do |worker|
      row = worker.join
    end
  else
    bmark_out = "/home/katei/ghq/github.com/kateinoigakukun/llvm-next-function-merging/build/bench-play/analysis/rustc-perf/plot-data/3-function-merge"
    tmpdir = "/tmp/llvm-nextfm-sweetspot"
    llc = "llc-13"
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
end
