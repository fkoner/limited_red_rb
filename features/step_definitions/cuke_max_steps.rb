CUKE_MAX_EXECUTABLE = '../../../bin/cukepatch'

Given /^I have run "cukepatch ([^\"]*)"(?: (\d+) times?(?: in "([^\"]*)")?)?$/ do |cucumber_opts, count, build|
  count ||= 1
  @current_dir = working_dir + "/" + (build ? build : "")
  in_current_dir do
    count.to_i.times do
      run "#{(build ? "../" : "") + CUKE_MAX_EXECUTABLE} -q #{cucumber_opts}"
      Then "STDERR should be empty"
    end
  end
end

Given /^a Cucumber project "([^\"]*)" has a failing feature called "([^\"]*)"$/ do |dir, file|
  Given %Q{a standard Cucumber project directory structure in "#{dir}"}
  feature = <<-EOF
    Feature: Fickle
      Scenario: Fail
        Given failing
EOF
  And %Q{a file named "#{dir}/features/#{file}" with:}, feature
  steps = <<-EOF
    Given "failing" do
      fail
    end
EOF
  And %Q{a file named "#{dir}/features/step_definitions/steps.rb" with:}, steps 
end

When /^I run "cukepatch ([^\"]*)"(?: in "([^\"]*)")?$/ do |cucumber_opts, build|
  @current_dir = working_dir + "/" + (build ? build : "")
  in_current_dir do
    run "#{(build ? "../" : "") + CUKE_MAX_EXECUTABLE} #{cucumber_opts}"
    Then "STDERR should be empty"
  end
end

Then /^"([^\"]*)" should be run first$/ do |feature_file|
  last_stdout.scan(/#\s*(.*\.feature)/).flatten[0].should == feature_file
end

Then /^"([^\"]*)" should not be run$/ do |feature_file|
  last_stdout.should_not include(feature_file)
end
