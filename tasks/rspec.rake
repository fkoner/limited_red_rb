begin
require 'rspec'
require 'rspec/core/rake_task'


desc "Run all specs"
RSpec::Core::RakeTask.new('specs') do |t|
end

rescue LoadError
  puts "Rspec (or a dependency) not available."
end