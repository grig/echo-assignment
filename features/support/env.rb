#system("/Users/grig/local/yaws/bin/yaws --daemon")
system("erl -pa ebin -pa /Users/grig/local/yaws/lib/yaws/ebin -sname cucumber -set-cookie cucumber -noshell&")
puts "starting sequence server..."
system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> sequence_app:start() end), init:stop().'")
puts "done"

at_exit do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> init:stop() end), init:stop().'")
end
