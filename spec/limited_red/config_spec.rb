require 'spec_helper'
require 'fakefs/spec_helpers'

module LimitedRed
  describe Config do
    include FakeFS::SpecHelpers
    
    before(:each) do
      FileUtils.mkdir_p "/home/josephwilk/test_project/"
      Dir.chdir '/home/josephwilk/test_project'
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
    
    context "Running limited for the first time on a machine" do
      it "should create a .limited-red config file in my home directory" do
        fake_stdin.add_input({:project_name => "test_project",
                              :username => 'josephwilk',
                              :api_key => '123'})

        config = Config.new(fake_stdin)
        
        
        config.load_and_validate_config
        
        File.should exists("/home/josephwilk/.limited-red")
      end
      
      it "should create a .limited-red config file in my project directory" do
        fake_stdin.add_input({:project_name => "test_project",
                              :username => 'josephwilk',
                              :api_key => '123'})
                
        config = Config.new(fake_stdin)
        
        config.load_and_validate_config
        
        File.should exists("/home/josephwilk/test_project/.limited-red")
      end
    end
  end
end