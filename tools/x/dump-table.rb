require "fileutils"

class ContinuousIntegration
  def download_ci_artifacts(run_id)
    $stderr.puts "Downloading artifacts for run #{run_id}"
    dir = "ci-artifacts/#{run_id}"
    result = { dir: dir }
    return result if Dir.exist?(dir)
    FileUtils.mkdir_p(dir)
    %x{gh run download #{run_id} --dir #{dir}}
    result
  end

  def latest_successful_run_id
    %x(gh run list -w .github/workflows/test.yml --json status,conclusion,databaseId,startedAt | jq '.[] | select(.conclusion == "success") | .databaseId' | head -n1).strip
  end
end

module TexReport
  def self.stats_objsize(result)
    variants = Dir.glob "#{result[:dir]}/benchmark-out-*"
    results = {}
    variants.each do |variant|
      variant_name = File.basename(variant).sub("benchmark-out-", "")
      objects = Dir.glob "#{variant}/*/obj.strip.o"
      objects.each do |object|
        testsuite = File.basename(File.dirname(object))
        testsuite = self.normalize_testsuite_name(testsuite)
        results[testsuite] ||= {}
        results[testsuite][variant_name] = File.size(object)
      end
    end
    results
  end

  def self.generate_objsize_csv(result)
    results = self.stats_objsize(result)
    variants = results.values.map(&:keys).flatten.uniq.sort
    csv = "testsuite," + variants.join(",")
    results.each do |testsuite, variants|
      csv += "\n"
      csv += "#{testsuite}," + variants.values.map(&:to_s).join(",")
    end
    puts csv
  end

  def self.generate_table(result)
    results = self.stats_objsize(result)
    variants = results.values.map(&:keys).flatten.uniq.sort
    puts "\\begin{table}[ht]"
    puts "\\centering"
    puts "\\begin{tabular}{l#{'r' * variants.size}}"
    puts "\\hline"
    puts "Test Suite & #{variants.join(' & ')} \\\\"
    puts "\\hline"
    puts "\\hline"
    results.each do |testsuite, variants|
      puts "#{self.escape testsuite} & #{variants.values.map { |v| v.join(' & ') }.join(' & ')} \\\\"
    end
    puts "\\hline"
    puts "\\end{tabular}"
    puts "\\end{table}"
  end

  def self.escape(str)
    str.gsub("_", "\\_")
  end

  def self.normalize_testsuite_name(name)
    name.sub(/_test$/, "")
  end
end

working_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".x"))

FileUtils.mkdir_p(working_dir)
Dir.chdir working_dir do
  ci = ContinuousIntegration.new
  run_id = ci.latest_successful_run_id
  result = ci.download_ci_artifacts(run_id)
  # TexReport.generate_table(result)
  TexReport.generate_objsize_csv(result)
end
