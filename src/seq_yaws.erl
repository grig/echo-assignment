-module(seq_yaws).
% controls embedded yaws instance

% API
-export([start/1]).

start(Port) ->
    {ok, Cwd} = file:get_cwd(),
    SconfList = [{port, Port},
                 {listen, {0, 0, 0, 0}},
                 {appmods, [{"/", seq_appmod}]}],
    ok = yaws:start_embedded(Cwd, SconfList).
