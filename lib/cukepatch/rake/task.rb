require 'cucumber/rake/task'
require File.dirname(__FILE__) + '/../../cukepatch'

module CukePatch
  module Rake
    class Task < Cucumber::Rake::Task
      def initialize(task_name = "cukepatch", desc = "Run Cucumber features ordered by likelihood of failure")
        super
        cukepatch = CukePatch::Cli.cukepatch(self.cucumber_opts)
        self.cucumber_opts = cukepatch.extended_args
      end
    end
  end
end