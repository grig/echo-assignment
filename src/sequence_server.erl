-module(sequence_server).
-compile(export_all).

start() ->
    SS = spawn(?MODULE, loop, [[]]),
    register(sequence_server, SS).

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

stop() ->
    rpc(whereis(sequence_server), stop).

register(Val) ->
    rpc(whereis(sequence_server), {register, Val}).

get() ->
    rpc(whereis(sequence_server), get).

rpc(Pid, Q) ->
    Pid ! { self(), Q },
    receive
        { Pid, Val } -> Val
    end.
