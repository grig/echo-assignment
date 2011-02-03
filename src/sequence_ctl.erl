-module(sequence_ctl).
% controlling functions to be used during accptance tests

-compile(export_all).

start_app() ->
  {ok, Hostname} = inet:gethostname(),
  Node = list_to_atom("cucumber@"++Hostname),
  spawn(Node, fun() -> application:start(sequence_app) end),
  init:stop().

stop_app() ->
  {ok, Hostname} = inet:gethostname(),
  Node = list_to_atom("cucumber@"++Hostname),
  spawn(Node, fun() -> init:stop() end),
  init:stop().

start_server() ->
  {ok, Hostname} = inet:gethostname(),
  Node = list_to_atom("cucumber@"++Hostname),
  spawn(Node, fun() -> sequence_server:set_conf([{max_sequences, 1}]) end),
  init:stop().

stop_server() ->
  {ok, Hostname} = inet:gethostname(),
  Node = list_to_atom("cucumber@"++Hostname),
  %% spawn(Node, fun() -> sequence_server:stop() end),
  init:stop().

reload() ->
  {ok, Hostname} = inet:gethostname(),
  Node = list_to_atom("cucumber@"++Hostname),
  Config = seq_conf:load("tmp/sequence_server.config"),
  spawn(Node, fun() -> sequence_server:set_conf(Config) end),
  init:stop().
