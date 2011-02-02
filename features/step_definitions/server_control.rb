require 'fileutils'

Given /^a running sequence server$/ do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> sequence_server:start_link() end), init:stop().'")
end

After do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> sequence_server:stop() end), init:stop().'")
end

Given /^a sequence server with a following configuration:$/ do |config|
  FileUtils.mkdir_p "tmp"
  File.open("tmp/sequence_server.config", "w") do |f|
    f.write(config)
  end
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'Config = seq_conf:load(\"tmp/sequence_server.config\"), spawn_link(cucumber@host2, fun() -> sequence_server:set_conf(Config) end), init:stop().'")
end

