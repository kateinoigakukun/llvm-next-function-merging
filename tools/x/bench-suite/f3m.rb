require "rake"
require_relative "../build"

class F3M < Rake::TaskLib
  def initialize(build)
    @build = build
    @suite_dir = File.expand_path(File.dirname(__FILE__))
  end

  def download
    path = File.join(@build.dot_x_dir, "bench-suite", "f3m", "f3m-cgo22-artifact.v4.tar")
    mkdir_p File.dirname(path)
    unless File.exist? path
      sh "curl -L https://figshare.manchester.ac.uk/ndownloader/files/31764461 -o #{path}"
    end
    path
  end

  def extract(tar)
    path = File.join(@build.dot_x_dir, "bench-suite", "f3m", "f3m-cgo22-artifact.v4")
    unless File.exist? path
      mkdir_p path
      sh "tar xf #{tar} -C #{path} --strip-components=1"
      sh "patch -p0 < #{File.join(@suite_dir, "f3m", "setup.sh.patch")}", chdir: path
      # Build patched GNU time
      sh "bash ./setup.sh", chdir: path
    end
    path
  end

  def run
    tar = download
    dir = extract tar
    # sh "#{@suite_dir}/f3m/experiments/exp.1.build.py"
    sh "#{@suite_dir}/f3m/experiments/exp.2.run.py"
  end
end

def main
  task = F3M.new Build.new
  task.run
end

main if __FILE__ == $0
