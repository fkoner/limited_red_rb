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
    end

    let(:fake_stdout){ StringIO.new }
    let(:fake_http_adapter){ FakeHTTPAdapter.new }
    
    describe '#log_result' do

      it "should post the build data" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter)
                
        fake_http_adapter.should_receive(:post).with("/projects/blah/builds/123/results", {:body=> {:user=>"josephwilk", 
                                                                                                    :fails=>"", 
                                                                                                    :passes=>"", 
                                                                                                    :result=>"", 
                                                                                                    :build_id=>123, 
                                                                                                    :token=>"c858f6946b5f2c34f6c4e39d4aae862526a9c358"}})
        
        build_data = {:fails => "",
                      :passes => "",
                      :result => "",
                      :build_id => 123}
        
        client.log_result(build_id = 123, build_data)
      end
    end
    
    describe '#log_build' do
      it "should post the build data" do
        client = Client.new(test_config, fake_stdout, fake_http_adapter)
        
        fake_http_adapter.should_receive(:post).with("/projects/blah/builds", {:body=> {:user=>"josephwilk", 
                                                                                        :passes=>"", 
                                                                                        :fails=>"",
                                                                                        :result=>"", 
                                                                                        :build_id=>123, 
                                                                                        :token=>"c858f6946b5f2c34f6c4e39d4aae862526a9c358"}})
                
        build_data = {:fails => "",
                      :passes => "",
                      :result => "",
                      :build_id => 123}
        
        client.log_build(build_id = 123, build_data)
      end
    end
  end
end