-module(sequence_tests).
-include_lib("eunit/include/eunit.hrl").

-define(assertSeqEqual(List, Seq),
        ?assertEqual(length(List), sequence:length(Seq)),
        ?assertEqual(List, sequence:to_list(Seq))).

new_seq_should_be_empty_test() ->
    ?assertSeqEqual([], seq([])).

insert_of_element_into_empty_seq_should_increment_length_test() ->
    ?assertSeqEqual([1], seq([1])).

insert_of_larger_element_should_increase_sequence_test() ->
    ?assertSeqEqual([1,2,3], seq([1,2,3])).

insert_of_smaller_element_should_reset_sequence_test() ->
    ?assertSeqEqual([1,2], seq([2,1,2])).

% inserts elements of L into an empty sequence and returns resulting sequence
seq(L) ->
    lists:foldl(fun sequence:insert/2, sequence:new(), L).
