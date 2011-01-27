-module(sequence_server).
-compile(export_all).

start() ->
    yaws:start_embedded("/Users/grig/Projects/echo-generators/",
                        [{port, 8081},
                         {listen, {0, 0, 0, 0}},
                         {appmods, [{"/", sg_appmod}]}]),
    SS = spawn(?MODULE, loop, [[]]),
    register(sequence_server, SS).

stop() ->
    yaws:stop(),
    Pid = whereis(sequence_server),
    Pid ! { self(), stop },
    receive
        { Pid, Reply } -> Reply
    end.

loop(L) ->
    receive
        {Pid, stop} ->
            Pid ! {self(), ok};
        {Pid, {register, Num}} ->
            Pid ! {self(), ok},
            loop([Num | L]);
        {Pid, get} ->
            Pid ! {self(), L},
            loop(L)
    end.

%% register(Num) ->
%%     sequence_server ! { self(), {register, Num} },
%%     Pid = whereis(sequence_server),
%%     receive
%%         { Pid, Val } -> Val
%%     end.

%% get() ->
%%     sequence_server ! { self(), get},
%%     Pid = whereis(sequence_server),
%%     receive
%%         { Pid, Val } -> Val
%%     end.
