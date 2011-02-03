-module(sequence_ctl).
% Stupid remote-control interface for sequence server

-compile(export_all).

start_app() ->
  ctl(fun() -> sequence_app:start() end),
  init:stop().

stop_app() ->
  ctl(fun() -> init:stop() end),
  init:stop().

start_server() ->
  ctl(fun() -> sequence_server:set_conf([{max_sequences, 1}]) end),
  init:stop().

stop_server() ->
  init:stop().

reload() ->
  Config = seq_conf:load("tmp/sequence_server.config"),
  ctl(fun() -> sequence_server:set_conf(Config) end),
  init:stop().

ctl(F) ->
    {ok, Hostname} = inet:gethostname(),
    Node = list_to_atom("cucumber@"++Hostname),
    spawn(Node, F).
