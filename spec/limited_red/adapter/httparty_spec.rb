require 'spec_helper'

module LimitedRed::Adapter
  describe HttParty do
    describe "#encode_and_compress" do
      def gzip_and_encode(data)
        Base64.encode64(LimitedRed::Gzip.compress(data))
      end
      
      it "should Gzip and base64 the data" do
        http_party = HttParty.new({})

        result = http_party.encode_and_compress("data")
        
        result.should == gzip_and_encode("data")
      end
      
    end
  end
end