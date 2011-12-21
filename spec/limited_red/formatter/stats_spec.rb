require 'spec_helper'

module LimitedRed::Formatter
  describe Stats do
    describe "#new" do
      let(:fake_config){ mock(Config) }
      
      it "should create a limited red client with config" do
        LimitedRed::Config.stub!(:load_and_validate_config).and_return(fake_config)
        
        LimitedRed::Client.should_receive(:new).with(fake_config)
        
        Stats.new(mock('step_mother'), mock('path_or_io'), {})
      end
      
    end
    
    describe "#after_feature" do
      
    end

    describe "#after_features" do
      
    end
    
  end
end