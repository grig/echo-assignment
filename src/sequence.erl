-module(sequence).
-compile(export_all).

-type seq() :: {integer(), [integer()]}.

-spec(new() -> seq()).
new() -> {0, []}.

%% TODO: cache sequence length in a tuple
-spec length(seq()) -> integer().
length({Len, _Seq}) -> Len.

-spec insert(integer(), seq()) -> seq().
insert(Num, {0, []}) -> {1, [Num]};
insert(Num, {Len, L = [H|_T]}) when Num > H -> {Len + 1, [Num | L]};
insert(Num, {_Len, [H|_T]}) when Num =< H -> {1, [Num]}.

-spec to_list(seq()) -> [integer()].
to_list({_Len, Seq}) ->
    lists:reverse(Seq).
