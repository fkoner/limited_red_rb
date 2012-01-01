require 'rspec/core/formatters/helpers'
require 'rspec/core/formatters/base_formatter'

module LimitedRed
  module Rspec
    module Formatter  
      class Stats < ::RSpec::Core::Formatters::BaseFormatter
        
        def example_passed(example)
          puts example.to_json
        end
        
        def example_failed(example)
          puts example.to_json
        end
        
      end
    end
  end
end