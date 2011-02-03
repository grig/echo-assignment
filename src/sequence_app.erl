-module(sequence_app).
-compile(export_all).

start() ->
    {ok, Cwd} = file:get_cwd(),
    Port = 8081,
    yaws:start_embedded(Cwd,
                        [{port, Port},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]),
    sequence_server:start_link().

start(ConfigFile) ->
    {ok, Cwd} = file:get_cwd(),
    Config = seq_conf:load(ConfigFile),
    Port = seq_conf:get_env(Config, port, 8081),
    yaws:start_embedded(Cwd,
                        [{port, Port},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]),
    MaxSequences = seq_conf:get_env(Config, max_sequences, 1),
    sequence_server:start_link([{max_sequences, MaxSequences}]).

stop() ->
    yaws:stop(),
    sequence_server:stop().
