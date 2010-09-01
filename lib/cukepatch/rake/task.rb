require 'cucumber/rake/task'
require File.dirname(__FILE__) + '/../../cukemax'

module CukeMax
  module Rake
    class Task < Cucumber::Rake::Task
      def initialize(task_name = "cukemax", desc = "Run Cucumber features ordered by likelihood of failure")
        super
        cukemax = CukeMax::Cli.cukemax(self.cucumber_opts)
        self.cucumber_opts = cukemax.extended_args
      end
    end
  end
end