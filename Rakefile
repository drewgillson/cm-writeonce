require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "cm-writeonce"
  gem.homepage = "https://github.com/drewgillson/cm-writeonce"
  gem.license = "MIT"
  gem.summary = %Q{Load subscribers into CampaignMonitor without overwriting the source field}
  gem.description = ""
  gem.email = "drew.gillson@gmail.com"
  gem.authors = ["Drew Gillson"]
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cm-writeonce #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end