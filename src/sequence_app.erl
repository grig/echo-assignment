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
    {ok, Cwd} = file:get_cwd(),
    yaws:start_embedded(Cwd,
                        [{port, Port},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]),
    sequence_server:start_link([{max_sequences, MaxSequences}]).

stop() ->
    yaws:stop(),
    sequence_server:stop().
