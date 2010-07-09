Given /^a feature named "([^\"]*)" which (?:always )?fails$/ do |name|
  feature = <<-EOF
  Feature: Fickle
    Scenario: Failer
      Given failing
EOF
  
  steps = <<-EOF
  Given /^failing$/ do
    fail
  end
EOF
  Given %Q{a file named "#{name}" with:}, feature
  Given %Q{a file named "features/step_definitions/fail_steps.rb" with:}, steps
end

Given /^the feature "([^\"]*)" is deleted$/ do |file|
  in_current_dir do
    File.delete(file)
  end
end

Given /^the feature "([^\"]*)" is fixed$/ do |file|
  in_current_dir do
    feature = File.read(file)
    feature.gsub!(/Given failing/, 'Given passing')
    feature.gsub!(/Fail/, 'Pass')
    File.open(file, 'w') do |f|
      f.write(feature)
    end
  end
end

Given /^the feature "([^\"]*)" is broken$/ do |file|
  in_current_dir do
    feature = File.read(file)
    feature.gsub!(/Given passing/, 'Given failing')
    feature.gsub!(/Pass/, 'Fail')
    File.open(file, 'w') do |f|
      f.write(feature)
    end
  end
end

Given /^a feature named "([^\"]*)" which (?:always )?passes$/ do |name|
  feature = <<-EOF
   Feature: Passing
     Scenario: Pass
       Given passing
 EOF

   steps = <<-EOF
   Given /^passing$/ do
   end
 EOF
  Given %Q{a file named "#{name}" with:}, feature
  Given %Q{a file named "features/step_definitions/pass_steps.rb" with:}, steps
end
