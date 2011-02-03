-module(seq_yaws).
% controls embedded yaws instance

% API
-export([start/2]).

start(Cwd, Port) ->
    yaws:start_embedded(Cwd,
                        [{port, Port},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]).
