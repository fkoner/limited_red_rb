require 'cucumber/rake/task'
require File.dirname(__FILE__) + '/../../cukepatch'

module CukePatch
  module Rake
    class Task < Cucumber::Rake::Task
      def initialize(task_name = "cukemax", desc = "Run Cucumber features ordered by likelihood of failure")
        super
        cukemax = CukePatch::Cli.cukemax(self.cucumber_opts)
        self.cucumber_opts = cukemax.extended_args
      end
    end
  end
end