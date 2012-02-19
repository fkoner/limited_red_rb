require 'spec_helper'

module LimitedRed::Cucumber::Formatter
  describe Stats do
    let(:fake_step_mother){ mock('step_mother') }
    let(:fake_path_or_io){ mock('path_or_io').as_null_object }
    let(:fake_config){ mock(Config) }
    
    before(:each) do
      LimitedRed::Config.stub!(:load_and_validate_config).with('cucumber').and_return(fake_config)
      LimitedRed::ThreadPool.stub!(:wait_for_all_threads_to_finish)
    end
    
    describe "#new" do
      it "should create a limited red client with config" do
        LimitedRed::Config.stub!(:load_and_validate_config).with('cucumber').and_return(fake_config)
        
        LimitedRed::Client.should_receive(:new).with(fake_config)
        
        Stats.new(fake_step_mother, fake_path_or_io, {})
      end
    end
    
    describe "#after_feature" do
      let(:fake_feature){mock("fake_feature", :to_json => "{'FEATURE JSON'}")}

      class FakeGherkinFormatter
        def initialize(json)
          @feature_hash = json
        end
      end
      
      it "should use the current time as the build id posted to the client" do
        client = mock(LimitedRed::Client)
        LimitedRed::Client.stub(:new).and_return(client)

        Time.stub!(:now).and_return(1324468723)
        
        stats = Stats.new(fake_step_mother, fake_path_or_io, {})
        stats.instance_variable_set("@gf", FakeGherkinFormatter.new(fake_feature))
        
        client.should_receive(:log_result).with(1324468723, anything)
        
        stats.after_feature(mock("feature result"))
      end
      
      it "should log the feature json with the client" do
        client = mock(LimitedRed::Client)
        LimitedRed::Client.stub(:new).and_return(client)  

        stats = Stats.new(fake_step_mother, fake_path_or_io, {})
        
        #TODO: How does this get set by Cucumber/Gherkin?
        stats.instance_variable_set("@gf", FakeGherkinFormatter.new(fake_feature))
        
        client.should_receive(:log_result).with(anything, {:result => "{'FEATURE JSON'}"} )
        
        stats.after_feature(mock("feature result"))
      end
    end

    describe "#after_features" do
      def scenario(file_and_line)
        scenario = mock(Cucumber::Ast::Scenario, :file_colon_line => file_and_line)
        scenario.stub!(:is_a?).with(Cucumber::Ast::Scenario).and_return(true)
        scenario.stub!(:is_a?).with(Cucumber::Ast::OutlineTable::ExampleRow).and_return(false)
        scenario
      end
      
      it "should log all the failing and passing feature files" do
        client = mock(LimitedRed::Client)
        LimitedRed::Client.stub(:new).and_return(client)

        fake_step_mother.stub!(:scenarios).with(:failed).and_return([scenario(file_line="example.feature:2")])
        fake_step_mother.stub!(:scenarios).with(:passed).and_return([scenario(file_line="another.feature:4")])
        
        stats = Stats.new(fake_step_mother, fake_path_or_io, {})
        
        client.should_receive(:log_build).with(anything, {:fails =>  ['example.feature:2'], 
                                                          :passes => ['another.feature:4']} )
        
        stats.after_features(mock("features"))
      end
      
    end
    
  end
end