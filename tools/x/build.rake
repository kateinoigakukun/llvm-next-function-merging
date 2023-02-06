require "rake"
require "rake/tasklib"

class Build < Rake::TaskLib
  def initialize
    @repo_root = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
    @build_dir = File.join(@repo_root, ".x", "build", "RelWithDebInfo")
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
  def opt_speed_test
    require "benchmark"
    time = Benchmark.realtime do
      sh *speed_test_target
    end
    puts "Optimization took #{time} seconds"
  end

  def perf_opt_speed_test
    perf_data = File.join(@repo_root, ".x", "perf", "opt-speed-test.data")
    mkdir_p File.dirname(perf_data)
    sh "perf", "record", "--call-graph", "dwarf",
      "-o", perf_data, "--", *speed_test_target
  end

  def speed_test_target
    [
      "/usr/lib/llvm-13/bin/opt",
      "--load", @pass_plugin,
      "--load-pass-plugin", @pass_plugin,
      "-S", "--passes=multiple-func-merging",
      "-func-merging-explore=2", "-o", "/dev/null",
      File.join(@repo_root, "test/Transforms/NextFM/CodeGen/mibench-automotive-susan/1_multiple-func-merging_Alignment.ll")
    ]
  end
end

def main
  require "optparse"
  opt = OptionParser.new
  build = Build.new
  opt.on("--opt-speed-test") do
    build.build
    build.opt_speed_test
  end
  opt.on("--perf-opt-speed-test") do
    build.build
    build.perf_opt_speed_test
  end
  opt.parse!
end

main
