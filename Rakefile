require 'rubygems'
require "bundler/setup"
require 'rake'
# See http://www.rubygems.org/read/chapter/20 

def version
  @rpm_contrib_version ||= File.read("CHANGELOG")[/Version ([\d\.]+\w*)$/, 1]
end

RDOC_FILES = FileList['README*','LICENSE','CHANGELOG']
SUMMARY = "Contributed Instrumentation for New Relic RPM"
DESCRIPTION = <<-EOF
Community contributed instrumentation for various frameworks based on
the New Relic Ruby monitoring gem newrelic_rpm.
EOF

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rpm_contrib"
    gem.summary = SUMMARY
    gem.description = DESCRIPTION
    gem.email = "support@newrelic.com"
    gem.homepage = "http://github.com/newrelic/rpm_contrib"
    gem.authors = [ "Bill Kayser", "Jon Guymon" ]
    gem.add_dependency 'newrelic_rpm', '>=3.1.1'
    gem.version = version
    gem.files = FileList['LICENSE', 'README*', 'lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
    gem.rdoc_options <<
      "--line-numbers" <<
      "--inline-source" <<
      "--title" << SUMMARY <<
      "-m" << "README.md"
    gem.extra_rdoc_files = RDOC_FILES
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

#task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rpm_contrib #{version}"
  rdoc.main = "README.md"
  rdoc.rdoc_files =  FileList['lib/**/*.rb'] + RDOC_FILES
  rdoc.inline_source = true
end

begin
  require 'sdoc_helpers'
rescue LoadError
  puts "sdoc support not enabled. Please gem install sdoc-helpers."
end
