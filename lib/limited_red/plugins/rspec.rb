require 'limited_red'
require 'json'

RSpec.configure do |config|
  CLIENT = LimitedRed::Client.new(LimitedRed::Config.load_and_validate_config('rspec'))
  BUILD_ID = Time.now.to_i

  fails = []
  passes = []
  
  config.after(:each) do
    metadata = example.metadata
    full_description = example.metadata[:full_description]
    
    file = example.metadata[:file_path]
    file = file.gsub("#{Dir.pwd}/", '')

    line = example.metadata[:line_number]

    json = {:file =>  file, 
            :line => line, 
            :uri => full_description}.to_json
  
    if example.exception #Fail
      fails << "#{file}:#{line}"
      FakeWeb.allow_net_connect = true
      CLIENT.log_result(BUILD_ID, :result => json)
      FakeWeb.allow_net_connect = false
    else # Pass
      passes << "#{file}:#{line}"
      FakeWeb.allow_net_connect = true
      CLIENT.log_result(BUILD_ID, :result => json)
      FakeWeb.allow_net_connect = false
    end
  end
  
  config.after(:suite) do
    FakeWeb.allow_net_connect = true
    CLIENT.log_build(BUILD_ID, {:fails => fails,
                                :passes => passes})
    FakeWeb.allow_net_connect = false
  end
end
