require 'net/http'
require 'test/unit'
include Test::Unit::Assertions

When /^I post string "([^"]*)" as "([^"]*)" to "([^"]*)"$/ do |number, content_type, path|
  req = Net::HTTP::Post.new(path)
  req.body = number
  req['Content-Type'] = content_type
  Net::HTTP.start('localhost', 8081) do |http|
    @response = http.request(req)
  end
end

When /^I send a GET request to "([^"]*)"$/ do |path|
  Net::HTTP.start('localhost', 8081) do |http|
    @response = http.get(path)
  end
end

Then /^I should receive HTTP status line "([^"]*)"$/ do |status_line|
  assert_equal status_line, "#{@response.code} #{@response.message}"
end

Then /^response body should look like the following:$/ do |expected|
  assert_equal expected, @response.body
end

