require 'limited_red'

RSpec.configure do |config|
  if ENV['LIMITED_RED'] || ENV['LIMITED_RED_API_KEY']
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
          CLIENT.log_fail_result(BUILD_ID,  :uri => metadata.uri, :result => metadata.to_json)
        end
      else # Pass
        passes << metadata.file_and_line
        CLIENT.log_pass_result(BUILD_ID, :uri => metadata.uri, :result => metadata.to_json)
      end
    end
  
    config.after(:suite) do
      CLIENT.log_build(BUILD_ID, {:fails => fails,
                                  :passes => passes})
    end

  end
end

at_exit{
  LimitedRed::ThreadPool.wait_for_all_threads_to_finish
}