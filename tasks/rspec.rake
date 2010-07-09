gem 'rspec', '>= 2.0.0.beta.13'
require 'rspec'

require 'rspec/core/rake_task'


desc "Run all specs"
RSpec::Core::RakeTask.new('specs') do |t|
end