-module(sequence_app).
-compile(export_all).

start() ->
    yaws:start_embedded("/Users/grig/Projects/echo-generators/",
                        [{port, 8081},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]),
    sequence_server:start().

stop() ->
    yaws:stop(),
    sequence_server:stop().
