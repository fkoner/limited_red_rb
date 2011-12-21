require 'spec_helper'
require 'fakefs/spec_helpers'

module LimitedRed
  describe Stats do
    describe "#feature_files" do
      let(:fake_client) { mock(Client) }
      
      context "feature file a.feature exists" do
        include FakeFS::SpecHelpers
        
        before(:each) do
          FileUtils.touch("a.feature")
        end
        
        it "should return a unique list of features that still exists on the file system" do
          Client.stub!(:new).and_return(fake_client)
          stats = Stats.new({})
        
          fake_client.stub!(:find_failing_features).and_return(["a.feature", "a.feature", "b.feature", "c.feature", "c.feature"])
        
          stats.feature_files.should == ["a.feature"]
        end
      end
    end
  end
end