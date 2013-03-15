require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rdoc/task'

RSpec::Core::RakeTask.new
RDoc::Task.new do |rd|
  rd.rdoc_files.include("lib/**/*.rb")
end
RDoc::Task.new(:clobber_rdoc => "rdoc:clean")

task :test => :spec
