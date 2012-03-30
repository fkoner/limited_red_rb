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
  
      without_fakeweb do
        CLIENT.log_result(BUILD_ID, :result => metadata.to_json, :uri => metadata.uri)
      end
    else # Pass
      passes << metadata.file_and_line
      without_fakeweb do
        CLIENT.log_result(BUILD_ID, :result => metadata.to_json, :uri => metadata.uri)
      end
    end
  end
  
  config.after(:suite) do
    without_fakeweb do
      CLIENT.log_build(BUILD_ID, {:fails => fails,
                                  :passes => passes})
    end
  end
  
  def without_fakeweb
    FakeWeb.allow_net_connect = true if defined?(FakeWeb)
    yield
    FakeWeb.allow_net_connect = false if defined?(FakeWeb)
  end
  
end
