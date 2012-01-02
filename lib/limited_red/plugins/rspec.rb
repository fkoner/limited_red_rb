RSpec.configure do |config|
  config.after(:each) do
    metadata = example.metadata
    full_description = example.metadata[:full_description]
    file, line = *(example.metadata[:example_group_block].source_location)
  
    if example.exception #Fail
      puts "FAIL", file, line
    else # Pass
      puts "PASS", file, line
    end
  end
end