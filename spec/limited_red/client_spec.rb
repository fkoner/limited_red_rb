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
      LimitedRed::Version::STRING = '6.6.6'
    end
    
    describe '#log_result' do

      it "should post the build data" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter, FakeThreadPool)
                
        fake_http_adapter.should_receive(:post).with("/projects/blah/builds/123/results", {:body=> {:user=>"josephwilk", 
                                                                                                    :fails=>"", 
                                                                                                    :passes=>"", 
                                                                                                    :result=>"", 
                                                                                                    :build_id=>123, 
                                                                                                    :version => '6.6.6',
                                                                                                    :token => "24877e67c60f45ba7330f1113a782118e7dafab9e9684bcba68e88528c05398e7d28498783bb2727ed62bb9e49863e6b6581341cc527923ecc533eed5c55d517"}})
        
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
        
        fake_http_adapter.should_receive(:post).with("/projects/blah/builds", {:body=> {:user=>"josephwilk", 
                                                                                        :passes=>"", 
                                                                                        :fails=>"",
                                                                                        :result=>"", 
                                                                                        :build_id=>123, 
                                                                                        :version => '6.6.6',
                                                                                        :token=>"24877e67c60f45ba7330f1113a782118e7dafab9e9684bcba68e88528c05398e7d28498783bb2727ed62bb9e49863e6b6581341cc527923ecc533eed5c55d517"}})
                
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
        
        fake_http_adapter.should_receive(:get).with("/projects/blah/features/fails?user=josephwilk")
                
        client.find_failing_features
      end
    end
  end
end