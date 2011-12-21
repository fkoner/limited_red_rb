require 'rubygems'
require 'tempfile'
begin
  require 'rspec/expectations'
rescue LoadError
  require 'spec/expectations'
end
require 'fileutils'
require 'forwardable'
require 'cucumber/formatter/unicode'

require 'mongo'
require 'childprocess' 

require File.dirname(__FILE__) + "/cucumber_support"

module ServiceRunner
  def self.service_ready?(url)
    begin
      Net::HTTP.get_response(URI.parse(url))
      true
    rescue
      false
    end
  end
  
  def self.start_limited_red_server
    @processes ||= {}
    return if @processes.has_key?('limited_red_server')
    FileUtils.cd('../limited_red_server') do
      process = @processes[service_name] = ChildProcess.build('rackup', 'config.ru')
      process.io.inherit! #If there are errors running ensure we see them
      process.start

      sleep(0) until service_ready?('http://localhost:4567')
    end
  end
  
end

if ENV['FULL_STACK']
  ServiceRunner.start_limited_red_server
else
  #Use fake limited_red_server
end


World do
  CucumberWorld.new
end


Before do
  FileUtils.rm_rf CucumberWorld.working_dir
  FileUtils.mkdir CucumberWorld.working_dir
end

After do
  FileUtils.rm_rf CucumberWorld.working_dir unless ENV['KEEP_FILES']
  terminate_background_jobs
  restore_original_env_vars
end
