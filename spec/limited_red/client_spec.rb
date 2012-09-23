require 'spec_helper'

module LimitedRed
  describe Client do
    def test_config
      {'host' => 'localhost',
       'port' => '80',
       'project name' => 'blah', 
       'username' => 'josephwilk',
       'api key' => '123'}
    end

    class FakeHTTPAdapter
      def encode_and_compress(data)
        data
      end
    end

    let(:fake_stdout){ StringIO.new }
    let(:fake_http_adapter){ FakeHTTPAdapter.new }

    before(:all) do
      @version ||= LimitedRed::Version::STRING 
      LimitedRed::Version::STRING = '6.6.6'
    end

    after(:all) do
      LimitedRed::Version::STRING = @version
    end
    
    describe '#log_result' do

      it "should post the build data" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter, FakeThreadPool)
                
        fake_http_adapter.should_receive(:post).with("/josephwilk/blah/builds/123/results", {:body=> {
                                                                                                    :fails=>"", 
                                                                                                    :passes=>"", 
                                                                                                    :result=>"", 
                                                                                                    :build_id=>123,
                                                                                                    :user=>"josephwilk", 
                                                                                                    :version => '6.6.6',
                                                                                                    :token => "cb07c5c711c99e340766f8984f8342c973663a863182c5e0b804964f1b8dc84a15cd05e3f66aac0cbabff9690aff0ce2c92f615679ac81bb515dfdbb375b3948"}})
        
        build_data = {:fails => "",
                      :passes => "",
                      :result => "",
                      :build_id => 123}
        
        client.log_result(build_id = 123, build_data)
      end
    end
    
    describe '#log_build' do
      it "should post the build data" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter, FakeThreadPool)
        
        fake_http_adapter.should_receive(:post).with("/josephwilk/blah/builds", {:body=>{:fails=>"", :passes=>"", :result=>"", :build_id=>123, :user=>"josephwilk", :version=>"6.6.6", 
                                                                                         :token=> "cb07c5c711c99e340766f8984f8342c973663a863182c5e0b804964f1b8dc84a15cd05e3f66aac0cbabff9690aff0ce2c92f615679ac81bb515dfdbb375b3948"}})    
        build_data = {:fails => "",
                     :passes => "",
                     :result => "",
                     :build_id => 123}
        
        client.log_build(build_id = 123, build_data)
      end
    end
    
    describe "#find_failing_features" do
      it "should make a request for the failing features" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter, FakeThreadPool)
        
        fake_http_adapter.should_receive(:get).with("/josephwilk/blah/features/fails")
                
        client.find_failing_features
      end
    end
  end
end
