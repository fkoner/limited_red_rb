Given /^a standard Rspec project directory structure$/ do
  @current_dir = working_dir
  in_current_dir do
    FileUtils.rm_rf 'spec' if File.directory?('spec')
  end
end

Given /^a spec named "([^\"]*)" which always fails$/ do |filename|
  
  file_content = <<EOS
require 'spec_helper'
  
describe 'something which should always fail' do
  it "should fail" do
    1.should == 2
  end
end
EOS
  
  create_file(filename,file_content)
end

Given /^a spec named "([^\"]*)" which always passes$/ do |filename|
  file_content = <<EOS
require 'spec_helper'
  
describe 'something which should always pass' do
  it "should pass" do
    10.should == 10
  end
end
EOS
  
  create_file(filename, file_content)
end

Given /^I have run "(.*)rspec ([^"]*)"$/ do |pre_options, specs|
  run "#{pre_options} rspec #{specs}"
end

When /^I run (.*) rspec ([^"]*)"$/ do |pre_options, specs|
  run "#{pre_options} rspec #{specs}"
end
