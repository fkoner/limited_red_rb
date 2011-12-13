require 'spec_helper'

module LimitedRed
  describe Config do
    context "Running limited for the first time on a machine" do
      it "should create a .limited-red config file in my home directory"
      it "should create a .limited-red config file in my project directory"
    end

  end
end