require 'cucumber/formatter/json'
require 'cukepatch/feature'

module CukePatch
  module Formatter  
    class Stats < Cucumber::Formatter::Json
      def initialize(step_mother, path_or_io, options)
        @build_id = Time.now.to_i
        @step_mother = step_mother
        Feature.load_config
 
        super
      end

      def after_features(features)
        feature_json = @json.to_json
        print_summary(feature_json)
      end

      def print_summary(feature_json)
        failures.each do |failed_feature|
          CukePatch::Feature.log_fail(@build_id, failed_feature)
        end
        passing.each do |passing_feature|
          CukePatch::Feature.log_pass(@build_id, passing_feature)
        end
        CukePatch::Feature.log_feature_data(@build_id, feature_json)
      end

      def failures
        failures = @step_mother.scenarios(:failed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
        failures.collect { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
      end

      def passing
        passing = @step_mother.scenarios(:passed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
        passing.collect { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }
      end
    end
  end
end