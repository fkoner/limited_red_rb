require 'httparty'
require 'json'
class CukeMaxClient
  include HTTParty
end

When /^I go to (.*)$/ do |url|
  @body = CukeMaxClient.get(url)
end

Then /^I should see JSON:$/ do |json_string|
  JSON.parse(@body).should == JSON.parse(json_string)
end
