require 'spec_helper'
require 'fakefs/spec_helpers'

module LimitedRed
  describe Config do
    class FakeSTDIN
      def initialize
      end

      def add_input(inputs)
        @strings = inputs.values
      end

      def readline
        next_string = @strings.shift
        next_string
      end
    end
    
    let(:fake_stdin){FakeSTDIN.new}
    let(:fake_stdout){StringIO.new}
    
    before(:each) do
      ENV['HOME'] = '/home/josephwilk'
      Dir.stub!(:glob).with("/home/josephwilk/.limited_red").and_return([])
      Dir.stub!(:glob).with('.limited_red').and_return([])
    end
    
    after(:each) do
      ENV['HOME'] = nil
    end
    
    context "Running limited red for the first time on a machine" do
      it "should create a .limited-red config file in my home directory and my project directory" do
        pending
        fake_stdin.add_input({:project_name => "test_project",
                              :username => 'josephwilk',
                              :api_key => '123'})

        config = Config.new(fake_stdout, fake_stdin)

        File.should_receive(:open).with("/home/josephwilk/.limited_red", "w")
        File.should_receive(:open).with(".limited_red", "w")
        
        config.load_and_validate_config
      end
    end
    
    context "Running limited red after having setup config files" do
      include FakeFS::SpecHelpers

      before(:each) do
        Dir.stub!(:glob).with("/home/josephwilk/.limited_red").and_return(['/home/josephwilk/.limited_red'])
        Dir.stub!(:glob).with('.limited_red').and_return(['.limited_red'])
        
        @shared_config = <<-EOS
host: localhost
port: 9292
username: josephwilk
api key: 123
EOS

        @project_config = <<-EOS
project name: cuke_internal_tests
EOS
      end
      
      it "should load the config from the two configuration files" do
        config = Config.new(fake_stdout, fake_stdin)
        
        IO.stub!(:read).with('/home/josephwilk/.limited_red').and_return(@shared_config)
        IO.stub!(:read).with('.limited_red').and_return(@project_config)
        
        config = config.load_and_validate_config
        
        config.should == {'host' => 'localhost',
                          'port' => 9292,
                          'username' => 'josephwilk',
                          'api key' => 123,
                          'project name' => 'cuke_internal_tests'}
      end
      
    end
  end
end