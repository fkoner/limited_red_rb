require 'spec_helper'

module CukeMax
  describe Cli do  
    it "should add the prioritised features before any other features" do
      cli = Cli.new(['features/'], nil)

      extended_args = cli.extend_for_cukemax(['joe.feature'])
      extended_args[0].should == 'joe.feature'
    end
    
    context "no formatter specified" do
      it "should add the pretty formatter" do
        cli = Cli.new(['features/'], nil)

        cli.extend_for_cukemax(["joe.feature"]).should include("pretty")
      end
    end

    context "a formatter is specified" do
      it "should not add the pretty formatter" do
        cli = Cli.new(['--format', 'progress'], nil)
      
        cli.extend_for_cukemax(["joe.feature"]).should_not include("pretty")
      end
    end
  end
end