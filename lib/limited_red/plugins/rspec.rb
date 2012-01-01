require "limited_red/rspec/formatter/stats"

config = RSpec.configuration
custom_formatter = LimitedRed::Rspec::Formatter::Stats.new(StringIO.new)
config.instance_variable_set(:@reporter, RSpec::Core::Reporter.new(custom_formatter))