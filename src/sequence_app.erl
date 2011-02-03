-module(sequence_app).
-export([start/0, start/1, stop/0]).

start() ->
    start(8081, 1).

start(ConfigFile) ->
    Config = seq_conf:load(ConfigFile),
    Port = seq_conf:get_env(Config, port, 8081),
    MaxSequences = seq_conf:get_env(Config, max_sequences, 1),
    start(Port, MaxSequences).

start(Port, MaxSequences) ->
    Pid = spawn(fun() ->
                        sequence_sup:start_link(Port, MaxSequences),
                        loop()
                end),
    register(sequence_app, Pid).

loop() ->
    receive
        stop -> io:format("stopping~n");
        Msg -> io:format("sequence_app:start received ~p~n", [Msg]),
               loop()
    end.

stop() ->
    sequence_app ! stop.
