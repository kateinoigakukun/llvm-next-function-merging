require "rake"
require "rake/tasklib"

class Build < Rake::TaskLib
  attr_reader :repo_root, :dot_x_dir, :build_dir, :trace_dir, :pass_plugin

  def initialize
    @repo_root = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
    @dot_x_dir = File.join(@repo_root, ".x")
    @build_dir = File.join(@dot_x_dir, "build", "RelWithDebInfo")
    @trace_dir = File.join(@dot_x_dir, "trace")
    @pass_plugin = File.join(@build_dir, "lib/LLVMNextFM.so")
  end

  def build
    llvm_path = "/usr/lib/llvm-13/cmake"
    Dir.chdir @repo_root do
      sh "cmake",
        "-B", @build_dir, "-G", "Ninja",
        "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
        "-DBUILD_TESTING=ON",
        "-DLLVM_DIR=#{llvm_path}"
      sh "cmake", "--build", @build_dir
    end
  end

  # Check how much time it takes to optimize a test file.
  def opt_speed_test(test_target, trace_filename = nil)
    require "benchmark"
    mkdir_p @trace_dir
    time = Benchmark.realtime do
      if trace_filename
        sh *trace_test_target(test_target, trace_filename)
      else
        sh *speed_test_target(test_target)
      end
    end
    puts "Optimization took #{time} seconds"
  end

  def perf_opt_speed_test(test_target, perf_data_filename)
    perf_data = File.join(@repo_root, ".x", "perf", perf_data_filename)
    mkdir_p File.dirname(perf_data)
    sh "perf", "record", "--call-graph", "dwarf", "-F", "99", "-o", perf_data, "--", *speed_test_target(test_target)
    perf_data
  end

  def speed_test_target(test_target)
    [
      "/usr/lib/llvm-13/bin/opt",
      "--load", @pass_plugin,
      "--load-pass-plugin", @pass_plugin,
      "-S", "--passes=multiple-func-merging",
      "-stats",
      "-multiple-func-merging-stats",
      "-func-merging-explore=2", "-o", "/dev/null",
      File.join(@repo_root, test_target)
    ]
  end

  def trace_test_target(test_target, trace_filename)
    speed_test_target(test_target) + %w[--time-trace --time-trace-file] + [
      File.join(@trace_dir, trace_filename)
    ]
  end

  def generate_flamegraph(perf_data)
    flamegraph_dir = File.join(@repo_root, ".x", "flamegraph")
    tools_dir = File.join(flamegraph_dir, "tools")
    unless File.exist?(tools_dir)
      mkdir_p tools_dir
      Dir.chdir tools_dir do
        sh "curl -o #{tools_dir}/stackcollapse-perf.pl https://raw.githubusercontent.com/brendangregg/FlameGraph/master/stackcollapse-perf.pl"
        sh "curl -o #{tools_dir}/flamegraph.pl https://raw.githubusercontent.com/brendangregg/FlameGraph/master/flamegraph.pl"
      end
    end
    output = File.join(@repo_root, ".x", "flamegraph", "out", File.basename(perf_data) + "_flamegraph.svg")
    mkdir_p File.dirname(output)
    sh "perf script -i #{perf_data} | perl #{tools_dir}/stackcollapse-perf.pl | perl #{tools_dir}/flamegraph.pl > #{output}"
    output
  end

  def serve_http(&open)
    require "webrick"
    server = WEBrick::HTTPServer.new(
      # 9001 the port number that perfetto.dev allows to connect to by `connect-src`.
      # Also we use 127.0.0.1 instead of localhost for the same reason.
      Port: 9001,
      DocumentRoot: File.join(@repo_root, ".x"),
      StartCallback: proc do
        logger = server.logger
        logger.info("To access this server, open this URL in a browser:")
        server.listeners.each do |listener|
          logger.info("    http://#{listener.connect_address.inspect_sockaddr}")
        end
        if ENV["BROWSER"]
          open.call("http://127.0.0.1:9001") if block_given?
        end
      end,
      RequestCallback: proc do |req,res|
        res['Access-Control-Allow-Origin'] = '*'
      end
    )
    shut = proc {server.shutdown}
    siglist = %w"TERM QUIT"
    siglist.concat(%w"HUP INT") if STDIN.tty?
    siglist &= Signal.list.keys
    siglist.each do |sig|
      Signal.trap(sig, shut)
    end
    server.start
  end
end

def main
  require "optparse"
  opt = OptionParser.new
  build = Build.new
  test_target = "test/Transforms/NextFM/CodeGen/mibench-automotive-susan/1_multiple-func-merging_Alignment.ll"
  opt.on("--opt-speed-test") do
    trace_filename = File.basename(test_target) + ".json"
    build.build
    build.opt_speed_test(test_target, trace_filename)
    if ENV["BROWSER"]
      build.serve_http do |url|
        system(ENV["BROWSER"], "https://ui.perfetto.dev/#!/?url=#{url}/trace/#{trace_filename}")
      end
    end
  end
  opt.on("--perf-opt-speed-test") do
    perf_data_filename = File.basename(test_target) + "_" + Time.now.strftime("%Y%m%d%H%M%S") + ".data"
    build.build
    perf_data = build.perf_opt_speed_test(test_target, perf_data_filename)
    fg = build.generate_flamegraph(perf_data)
    build.serve_http do |url|
      system(ENV["BROWSER"], "#{url}/flamegraph/out/#{File.basename(fg)}")
    end
  end
  opt.parse!
end

if $0 == __FILE__
  main
end
