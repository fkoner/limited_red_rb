require 'spec_helper'

module LimitedRed::Adapter
  describe HttParty do
    describe "#encode_and_compress" do
      it "should Gzip and base64 the data" do
        http_party = HttParty.new({})

        result = http_party.encode_and_compress("data")
        
        result.should == "ZGF0YQ==\n"
      end
      
    end
  end
end