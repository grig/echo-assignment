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
            L1 = update_sequence(Num, L),
            loop(L1);
        {Pid, get} ->
            Pid ! {self(), lists:reverse(L)},
            loop(L)
    end.

update_sequence(Num, []) -> [Num];
update_sequence(Num, L = [H|_T]) when Num > H -> [Num | L];
update_sequence(Num, [H|_T]) when Num =< H -> [Num].

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
