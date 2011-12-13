require 'cucumber/formatter/json'
require 'limited_red/feature'

module LimitedRed
  module Formatter  
    class Stats < Cucumber::Formatter::Json
      
      def initialize(step_mother, path_or_io, options)
        @t = Time.now
        @build_id = Time.now.to_i
        @step_mother = step_mother
        Feature.load_config

        super
      end

      def after_feature(feature)
        compressed_result = Gzip.compress(@current_object.to_json)
        LimitedRed::Feature.log_result(@build_id, :result => compressed_result)
      end

      def after_features(features)
        print_summary
      end

      def print_summary
        LimitedRed::Feature.log_build(@build_id, {:fails => failing_files, 
                                                 :passes => passing_files})
                                                   
        ThreadPool.wait_for_all_threads_to_finish
      end

      def failing_files
        failures = @step_mother.scenarios(:failed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
        failures = failures.collect { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
        failures.map{|fail| fail.file_colon_line}
      end

      def passing_files
        passing = @step_mother.scenarios(:passed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
        passing = passing.collect { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
        passing.map{|pass| pass.file_colon_line}
      end
    end
  end
end