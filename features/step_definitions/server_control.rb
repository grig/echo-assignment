require 'fileutils'

Given /^a running sequence server$/ do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl start_server")
end

After do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl stop_server")
end

Given /^a sequence server with a following configuration:$/ do |config|
  FileUtils.mkdir_p "tmp"
  File.open("tmp/sequence_server.config", "w") do |f|
    f.write(config)
  end
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl start_server")
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl reload")
end

