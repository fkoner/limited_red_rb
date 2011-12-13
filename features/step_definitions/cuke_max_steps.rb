require 'httparty'
require 'json'
class LimitedRedClient
  include HTTParty
end

When /^I go to (.*)$/ do |url|
  @body = LimitedRedClient.get(url)
end

Then /^I should see JSON:$/ do |json_string|
  JSON.parse(@body).should == JSON.parse(json_string)
end
