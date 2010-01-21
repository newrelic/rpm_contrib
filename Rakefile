require 'rubygems'
require 'rake'
# See http://www.rubygems.org/read/chapter/20 

def version
  @rpm_contrib_version ||= File.read("CHANGELOG")[/Version ([\d\.]+)$/, 1]
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rpm_contrib"
    gem.summary = %Q{Contributed Instrumentation for New Relic RPM}
    gem.description = <<-EOF
      Community contributed instrumentation for various frameworks based on
      the New Relic Ruby monitoring gem newrelic_rpm.
    EOF
    gem.email = "support@newrelic.com"
    gem.homepage = "http://github.com/newrelic/rpm_contrib"
    gem.author = "Bill Kayser"
    gem.add_dependency 'newrelic_rpm', '>= 2.10.2'
    gem.version = version
    gem.files = FileList['LICENSE', 'README*', 'lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rpm_contrib #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
