Before do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> sequence_server:start_link() end), init:stop().'")
end

After do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -eval 'spawn_link(cucumber@host2, fun() -> sequence_server:stop() end), init:stop().'")
end
