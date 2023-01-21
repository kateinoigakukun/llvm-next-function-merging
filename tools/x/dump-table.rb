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
    all_variants = results.values.map(&:keys).flatten.uniq.sort
    csv = "testsuite," + all_variants.map { |v| self.normalize_variant_name(v) }.join(",")
    results.each do |testsuite, variants|
      next if (variants.keys & all_variants).size != all_variants.size
      next if variants.values.uniq.size == 1
      csv += "\n"
      csv += "#{testsuite}," + variants.values.map(&:to_s).join(",")
    end
    puts csv
  end

  def self.generate_table(result)
    results = self.stats_objsize(result)
    all_variants = results.values.map(&:keys).flatten.uniq.sort
    puts "\\begin{table}[ht]"
    puts "\\centering"
    puts "\\begin{tabular}{l#{'r' * all_variants.size}}"
    puts "\\hline"
    puts "Test Suite & #{all_variants.map do |v|
      self.normalize_variant_name(v)
    end.join(' & ')} \\\\"
    puts "\\hline"
    puts "\\hline"
    results.each do |testsuite, variants|
      next if (variants.keys & all_variants).size != all_variants.size
      baseline = variants["baseline"]
      row = "#{self.escape testsuite} &"
      row += all_variants.map do |variant|
        next "N/A" unless variants[variant]
        next variants[variant].to_s if variant == "baseline"
        size = variants[variant]
        diff = size - baseline
        diff = diff.abs
        percent = diff.to_f / baseline * 100
        # SIZE (DIFF%)
        "#{size} (#{percent.round(1)}\\%)"
      end.join(' & ')
      row += " \\\\"
      puts row
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

  def self.normalize_variant_name(name)
    return "F3M" if name == "fm"
    case name
    when "fm" then "F3M"
    when "baseline" then "Baseline"
    when /mfm\+(\d+)/ then "MFM [e=#{$1}]"
    else raise "Unknown variant: #{name}"
    end
  end
end

working_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".x"))

FileUtils.mkdir_p(working_dir)
Dir.chdir working_dir do
  ci = ContinuousIntegration.new
  run_id = ci.latest_successful_run_id
  result = ci.download_ci_artifacts(run_id)
  method = ARGV[0]
  TexReport.send(method, result)
  # TexReport.generate_table(result)
  # TexReport.generate_objsize_csv(result)
end
