require 'limited_red'

RSpec.configure do |config|
  CLIENT = LimitedRed::Client.new(LimitedRed::Config.load_and_validate_config('rspec'))
  BUILD_ID = Time.now.to_i

  fails = []
  passes = []
  
  config.after(:each) do
    metadata = LimitedRed::Rspec::Metadata.new(example.metadata)
  
    if example.exception #Fail
      fails << metadata.file_and_line

      metadata.add_exception(example.exception)
      
      FakeWeb.allow_net_connect = true
      CLIENT.log_result(BUILD_ID, :result => metadata.to_json)
      CLIENT.log_result(BUILD_ID, :result => metadata.to_json, :pass => false)
      FakeWeb.allow_net_connect = false
    else # Pass
      passes << metadata.file_and_line
      FakeWeb.allow_net_connect = true
      CLIENT.log_result(BUILD_ID, :result => metadata.to_json)
      CLIENT.log_result(BUILD_ID, :result => metadata.to_json, :pass => true)
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
