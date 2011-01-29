-module(sequence_tests).
-include_lib("eunit/include/eunit.hrl").

new_seq_should_be_empty_test() ->
    S = sequence:new(),
    ?assertEqual(0, sequence:length(S)),
    ?assertEqual([], sequence:to_list(S)).

insert_of_element_into_empty_seq_should_increment_length_test() ->
    S = seq_from_list([1]),
    ?assertEqual(1, sequence:length(S)),
    ?assertEqual([1], sequence:to_list(S)).

insert_of_larger_element_should_increase_sequence_test() ->
    S = seq_from_list([1,2,3]),
    ?assertEqual(3, sequence:length(S)),
    ?assertEqual([1,2,3], sequence:to_list(S)).

insert_of_smaller_element_should_reset_sequence_test() ->
    S = seq_from_list([2,1,2]),
    ?assertEqual(2, sequence:length(S)),
    ?assertEqual([1,2], sequence:to_list(S)).

seq_from_list(L) ->
    lists:foldl(fun sequence:insert/2, sequence:new(), L).
