require 'spec_helper'
require 'fakefs/spec_helpers'

module LimitedRed
  describe Config do
    #TODO: Use fakefs when it works with expand
    #include FakeFS::SpecHelpers
    
    before(:each) do
      #FileUtils.mkdir_p "/home/josephwilk/test_project/"
      #Dir.chdir '/home/josephwilk/test_project'
    end
    
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
      Dir.stub!(:glob).with("/Users/josephwilk/.limited_red").and_return([])
      Dir.stub!(:glob).with('.limited_red').and_return([])
    end
    
    context "Running limited for the first time on a machine" do
      it "should create a .limited-red config file in my home directory and my project directory" do
        fake_stdin.add_input({:project_name => "test_project",
                              :username => 'josephwilk',
                              :api_key => '123'})

        config = Config.new(fake_stdout, fake_stdin)

        File.should_receive(:open).with("/Users/josephwilk/.limited_red", "w")
        File.should_receive(:open).with(".limited_red", "w")
        
        config.load_and_validate_config
      end
      
    end
  end
end