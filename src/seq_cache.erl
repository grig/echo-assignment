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
insert([], _Current) -> [];
insert(L = [H|T], Current) ->
    case sequence:length(Current) >= sequence:length(H) of
        true -> [ Current | truncate(L)];
        _ -> [ H | insert(T, Current)]
    end.

%% returns stored sequences as list of list of integers
-spec values(seq_cache()) -> [[integer()]].
values(Sequences) ->
    lists:filter(fun(X) -> X =/= [] end,
                 lists:map(fun sequence:to_list/1, Sequences)).

%%% helper: truncates the last element of the list
truncate(L) -> lists:sublist(L, length(L) - 1).
