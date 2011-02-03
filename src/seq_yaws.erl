-module(seq_yaws).
% controls embedded yaws instance

% API
-export([start/1, run/1]).

start(Port) ->
    {ok, spawn(?MODULE, run, [Port])}.

run(Port) ->
    {ok, Cwd} = file:get_cwd(),
    SconfList = [{port, Port},
                 {listen, {0, 0, 0, 0}},
                 {appmods, [{"/", seq_appmod}]}],
    {ok, SCList, GC, ChildSpecs} = yaws_api:embedded_start_conf(Cwd, SconfList),
    [supervisor:start_child(seq_yaws_sup, Ch) || Ch <- ChildSpecs],
    yaws_api:setconf(GC, SCList),
    {ok, self()}.
