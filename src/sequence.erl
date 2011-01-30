-module(sequence).
-compile(export_all).

-type seq() :: [integer()].

-spec(new() -> seq()).
new() -> [].

%% TODO: cache sequence length in a tuple
-spec length(seq()) -> integer().
length(Seq) -> erlang:length(Seq).

-spec insert(integer(), seq()) -> seq().
insert(Num, []) -> [Num];
insert(Num, L = [H|_T]) when Num > H -> [Num | L];
insert(Num, [H|_T]) when Num =< H -> [Num].

-spec to_list(seq()) -> [integer()].
to_list(Seq) ->
    lists:reverse(Seq).
