system("erl -pa ebin -pa \$YAWS_HOME/ebin -sname cucumber -set-cookie cucumber -noshell&")
puts "starting sequence server..."
system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl start_app")
puts "done"

at_exit do
  system("erl -pa ebin -sname cucumber_ctl -set-cookie cucumber -noshell -s sequence_ctl stop_app")
end
