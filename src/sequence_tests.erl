-module(sequence_tests).
-include_lib("eunit/include/eunit.hrl").

new_seq_should_be_empty_test() ->
    ?assertEqual(0, sequence:length(sequence:new())),
    ?assertEqual([], sequence:to_list(sequence:new())).

insert_of_element_into_empty_seq_should_increment_length_test() ->
    Seq = sequence:insert(1, sequence:new()),
    ?assertEqual(1, sequence:length(Seq)),
    ?assertEqual([1], sequence:to_list(Seq)).

insert_of_larger_element_should_increase_sequence_test() ->
    Seq = sequence:new(),
    Seq1 = sequence:insert(1, Seq),
    Seq2 = sequence:insert(2, Seq1),
    Seq3 = sequence:insert(3, Seq2),
    ?assertEqual(3, sequence:length(Seq3)),
    ?assertEqual([1,2,3], sequence:to_list(Seq3)).

insert_of_smaller_element_should_reset_sequence() ->
    Seq = sequence:new(),
    Seq1 = sequence:insert(2, Seq),
    Seq2 = sequence:insert(1, Seq1),
    Seq3 = sequence:insert(2, Seq2),
    ?assertEqual(2, sequence:length(Seq3)),
    ?assertEqual([1,2], sequence:to_list(Seq3)).
