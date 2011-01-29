-module(sequence_tests).
-include_lib("eunit/include/eunit.hrl").

-define(assertSeqEqual(List, Seq),
        ?assertEqual(length(List), sequence:length(Seq)),
        ?assertEqual(List, sequence:to_list(Seq))).

new_seq_should_be_empty_test() ->
    S = seq_from_list([]),
    ?assertSeqEqual([], S).

insert_of_element_into_empty_seq_should_increment_length_test() ->
    S = seq_from_list([1]),
    ?assertSeqEqual([1], S).

insert_of_larger_element_should_increase_sequence_test() ->
    S = seq_from_list([1,2,3]),
    ?assertSeqEqual([1,2,3], S).

insert_of_smaller_element_should_reset_sequence_test() ->
    S = seq_from_list([2,1,2]),
    ?assertSeqEqual([1,2], S).

seq_from_list(L) ->
    lists:foldl(fun sequence:insert/2, sequence:new(), L).
