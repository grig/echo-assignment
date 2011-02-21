-module(seq_yaws).
% controls embedded yaws instance

% API
-export([start/1]).

start(Port) ->
    {ok, Cwd} = file:get_cwd(),
    GConfList = [{flags, [{auth_log, false}]}],
    SConfList = [{port, Port},
                 {listen, {0, 0, 0, 0}},
		 {flags, [{access_log, false}]},
                 {appmods, [{"/", seq_appmod}]}],
    ok = yaws:start_embedded(Cwd, SConfList, GConfList).
