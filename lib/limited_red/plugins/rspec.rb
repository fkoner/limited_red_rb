require 'limited_red'
require 'limited_red/client'

RSpec.configure do |config|
  CLIENT = LimitedRed::Client.new(LimitedRed::Config.load_and_validate_config(:rspec))
  BUILD_ID = Time.now

  fails = []
  passes = []
  
  config.after(:each) do
    metadata = example.metadata
    full_description = example.metadata[:full_description]
    file, line = *(example.metadata[:example_group_block].source_location)

    json = {:file =>  file, 
            :line => line, 
            :uri => full_description}.to_json
  
    if example.exception #Fail
      fails << file
      CLIENT.log_result(BUILD_ID, :result => json)
      puts "Client FAIL", file, line
    else # Pass
      passes << file
      CLIENT.log_result(BUILD_ID, :result => json)
      puts "PASS", file, line
    end
  end
  
  config.after(:all) do
    CLIENT.log_build(BUILD_ID, {:fails => fails,
                                :passes => passes})
  end
end