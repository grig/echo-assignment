-module(seq_cache).

% seq_cache: a bounded cache of largest sequences
%
% seq_cache handles storing of at most N sequences. When a new
% sequence is inserted to an already-full cache, the shortest sequence
% is evicted from cache to make room for new one.
%
% Cache size is given in an argument to new/1.
%
% Implementation details:
%
% Cache is stored as an ordered list of sequences, ordered by their
% length in descending order. That is, for a cache limited to N
% elements [X_1, ..., X_N], we have that X_1 >= X_2 >= ... >= X_N.
%
% Cache is initialized as a list of empty sequences, its size equal to
% cache size. List size is then kept unchanged under all cache
% operations.
%
% When inserting a new sequence, the list is traversed from head to
% tail to find an insertion point. If one is found, the remainder of
% the list is truncated and appended to the new list. If insertion
% point is past the last element of the list, the sequence is silently
% dropped.
%
% TODO: invent a better name

-export([new/1, insert/2, values/1]).

%% creates a new sequence cache with given bound
-type sequence() :: term().
-type seq_cache() :: term().
-type bound() :: integer().
-spec new(bound()) -> seq_cache().
new(0) -> [];
new(N) -> [sequence:new() | new(N - 1) ].

%% inserts a new sequence in a sequence cache, evicting smaller
%% sequences if needed.
-spec insert(seq_cache(), sequence()) -> seq_cache().
insert(SC, Seq) ->
    [Drop|T] = insert2(SC, Seq),
    T.

% X1 <= x2 <= ... <= x_n
% s <= x1 -> [x1,x2,..., xn]
% s <= x2 -> [s, x2, ..., xn]
% s <= x3 -> [x2, s, x3, ..., xn]
insert2([], S) -> [S];
insert2(L=[H|T], S) ->
    case sequence:length(S) < sequence:length(H) of
             true -> [S|L];
             _ -> [H|insert2(T, S)]
    end.

%% returns stored sequences as list of list of integers
-spec values(seq_cache()) -> [[integer()]].
values(Sequences) ->
    lists:filter(fun(X) -> X =/= [] end,
                 lists:map(fun sequence:to_list/1, lists:reverse(Sequences))).

