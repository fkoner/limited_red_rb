require 'spec_helper'

module LimitedRed
  describe FeatureLogger do
    def test_config
      {'host' => 'localhost',
      'port' => '80',
      'project name' => 'blah', 
      'username' => 'josephwilk',
      'api key' => '123'}
    end
    
    describe '#log_result' do
      it "should post the build data" do
        Feature.load_config(test_config)
                
        FakeWeb.register_uri(:post, "http://localhost/projects/blah/builds/123/results", :body => "")
        
        build_data = {:fails => "",
                      :passes => "",
                      :result => "",
                      :build_id => 123}
        
        Feature.log_result(build_id = 123, build_data)
      end
    end
    
    describe '#log_build' do
      it "should post the build data" do
        Feature.load_config(test_config)
        
        FakeWeb.register_uri(:post, "http://localhost/projects/blah/builds", :body => "")
                
        build_data = {:fails => "",
                      :passes => "",
                      :result => "",
                      :build_id => 123}
        
        Feature.log_build(build_id = 123, build_data)
      end
    end
  end
end