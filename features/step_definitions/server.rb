require 'net/http'
require 'test/unit/assertions'
include Test::Unit::Assertions

def post(number, content_type, path)
  Net::HTTP.start('localhost', 8081) do |http|
    req = Net::HTTP::Post.new(path)
    req.body = number
    req['Content-Type'] = content_type
    @response = http.request(req)
  end
end

When /^I post string "([^"]*)" as "([^"]*)" to "([^"]*)"$/ do |number, content_type, path|
    post(number, content_type, path)
end

When /^I put a following sequence:$/ do |string|
  string =~ /\s*\[?([^\]]*)\]?\s*/
  xs = $1.to_s.split /,/
  xs.each { |x|
    post(x.strip, 'text/plain', '/put')
    assert @response.kind_of?(Net::HTTPSuccess), "number #{x} should be accepted with 200 OK, actual: #{@response.code}"
  }
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

