require 'cucumber'
require 'cucumber/formatter/json'
require 'limited_red/client'

module LimitedRed
  module Cucumber
    module Formatter  
      class Stats < ::Cucumber::Formatter::Json
      
        def initialize(step_mother, path_or_io, options)
          @t = Time.now
          @build_id = Time.now.to_i
          @step_mother = step_mother
          @client = LimitedRed::Client.new(LimitedRed::Config.load_and_validate_config(:cucumber))

          super
        end

        def after_feature(feature)
          if supports_feature_hash?
            json = feature_hash.to_json
            @client.log_result(@build_id, :result => json)
          else
            puts "[limited_red]:Error: Having trouble working with your Gherkin version. Is it upto date? Report this to joe@josephwilk.net, its his fault.", ""
          end
        end

        def after_features(features)
          print_summary
        end

        def print_summary
           @client.log_build(@build_id, {:fails => failing_files, 
                                         :passes => passing_files})
                                                   
          ThreadPool.wait_for_all_threads_to_finish
        end

        def failing_files
          failures = @step_mother.scenarios(:failed).select { |s| s.is_a?(::Cucumber::Ast::Scenario) || s.is_a?(::Cucumber::Ast::OutlineTable::ExampleRow) }
          failures = failures.collect { |s| (s.is_a?(::Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
          failures.map{|fail| fail.file_colon_line}
        end

        def passing_files
          passing = @step_mother.scenarios(:passed).select { |s| s.is_a?(::Cucumber::Ast::Scenario) || s.is_a?(::Cucumber::Ast::OutlineTable::ExampleRow) }
          passing = passing.collect { |s| (s.is_a?(::Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
          passing.map{|pass| pass.file_colon_line}
        end
      
        def supports_feature_hash?
          gherkin_formatter.instance_variables.include?('@feature_hash')
        end
      
        def feature_hash
          gherkin_formatter.instance_variable_get("@feature_hash")
        end
      
        def gherkin_formatter
          @gf
        end
      
      end
    end
  end
end