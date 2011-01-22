require 'net/http'
require 'test/unit'
include Test::Unit::Assertions

When /^I post number "([^"]*)" as "([^"]*)"$/ do |number, content_type|
  req = Net::HTTP::Post.new('/put')
  req.body = number
  req['Content-Type'] = content_type
  Net::HTTP.start('localhost', 8081) do |http|
    @response = http.request(req)
  end
end

Then /^I should receive HTTP status line "([^"]*)"$/ do |status_line|
  assert_equal status_line, "#{@response.code} #{@response.message}"
end

