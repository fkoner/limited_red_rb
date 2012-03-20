require 'spec_helper'

module LimitedRed::Rspec
  describe Metadata do
    let(:example_metadata) do
        {:example_group => {:example_group => {:description_args => ['LimitedRed::Adapter::HttParty'], :caller => []},
                            :full_description => "LimitedRed::Adapter::HttParty#encode_and_compress",
                            :description_args => ["#encode_and_compress"],
                            :caller => []},
         :full_description => "LimitedRed::Adapter::HttParty#encode_and_compress should Gzip and base64 the data",
         :description_args => ["should Gzip and base64 the data"],
         :file_path=>"/Users/josephwilk/Workspace/ruby/josephwilk/limited-red/limited_red_rb/spec/limited_red/adapter/httparty_spec.rb"}
    end
    
    describe "#to_json" do
      describe "the uri" do
        it "should be an concaternation of all the scopes" do
          @metadata = Metadata.new(example_metadata)
        
          data = JSON.parse(@metadata.to_json)
          
          data['uri'].should == 'limitedred::adapter::httparty-#encode_and_compress-should-gzip-and-base64-the-data'
        end
      end
    
      describe "the scopes" do
        it "should list all the 'describe' strings and the 'it' string" do
          @metadata = Metadata.new(example_metadata)

          data = JSON.parse(@metadata.to_json)

          data['scopes'].should == ['LimitedRed::Adapter::HttParty', '#encode_and_compress', 'should Gzip and base64 the data']
        end
      end
    end
    
  end
end  