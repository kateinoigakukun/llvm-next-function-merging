require "rake"
require "rake/tasklib"

class Build < Rake::TaskLib
  def initialize
    @repo_root = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
    @build_dir = File.join(@repo_root, ".x", "build", "RelWithDebInfo")
    @trace_dir = File.join(@repo_root, ".x", "trace")
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

  def perf_opt_speed_test(test_target)
    perf_data = File.join(@repo_root, ".x", "perf", "opt-speed-test.data")
    mkdir_p File.dirname(perf_data)
    sh "perf", "record", "-g", "-o", perf_data, "--", *speed_test_target(test_target)
  end

  def speed_test_target(test_target)
    [
      "/usr/lib/llvm-13/bin/opt",
      "--load", @pass_plugin,
      "--load-pass-plugin", @pass_plugin,
      "-S", "--passes=multiple-func-merging",
      "-func-merging-explore=2", "-o", "/dev/null",
      File.join(@repo_root, test_target)
    ]
  end

  def trace_test_target(test_target, trace_filename)
    speed_test_target(test_target) + %w[--time-trace --time-trace-file] + [
      File.join(@trace_dir, trace_filename)
    ]
  end

  def open_trace_ui(trace_filename)
    require "webrick"
    server = WEBrick::HTTPServer.new(
      # 9001 the port number that perfetto.dev allows to connect to by `connect-src`.
      # Also we use 127.0.0.1 instead of localhost for the same reason.
      Port: 9001,
      DocumentRoot: @trace_dir,
      StartCallback: proc do
        logger = server.logger
        logger.info("To access this server, open this URL in a browser:")
        server.listeners.each do |listener|
          logger.info("    http://#{listener.connect_address.inspect_sockaddr}")
        end
        if ENV["BROWSER"]
          system(ENV["BROWSER"], "https://ui.perfetto.dev/#!/?url=http://127.0.0.1:9001/#{trace_filename}")
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
      build.open_trace_ui(trace_filename)
    end
  end
  opt.on("--perf-opt-speed-test") do
    build.build
    build.perf_opt_speed_test
  end
  opt.parse!
end

main
