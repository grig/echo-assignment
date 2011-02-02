-module(sequence_server_tests).
-include_lib("eunit/include/eunit.hrl").

put_test_() ->
    [{foreach,
      fun setup/0,
      fun cleanup/1,
      [fun should_register_value/0,
       fun should_return_empty_list_on_empty_sequence/0,
       fun should_return_single_element/0,
       fun should_return_sequential_elements/0,
       fun should_reset_sequence_for_out_of_order_elements/0,
       fun should_return_largest_sequence_so_far/0,
       fun should_allow_to_reconfigure_itself/0,
       fun should_configure_max_sequences/0
      ]},
     sequence,
     seq_conf
    ].

multi_test_() ->
    {foreach,
     fun setup_multi/0,
     fun cleanup/1,
     [fun multi_server_should_return_empty_list_on_no_sequences/0,
      fun multi_server_should_return_single_sequence_when_only_one_sequence/0,
      fun multi_server_should_return_two_sequence_when_both_present/0,
      fun multi_server_should_register_subsequences/0,
      fun multi_server_should_handle_largest_sequence_correctly/0
     ]}.

setup_multi() ->
    sequence_server:start_link([{max_sequences, 2}]).

setup() ->
    sequence_server:start_link().

cleanup(_) ->
    sequence_server:stop().

should_register_value() ->
    ok = sequence_server:register(1).

should_return_empty_list_on_empty_sequence() ->
    ?assertEqual([], sequence_server:get()).

should_return_single_element() ->
    sequence_server:register(1),
    ?assertEqual([1], sequence_server:get()).

should_return_sequential_elements() ->
    sequence_server:register(1),
    sequence_server:register(2),
    ?assertEqual([1,2], sequence_server:get()).

should_reset_sequence_for_out_of_order_elements() ->
    sequence_server:register(2),
    sequence_server:register(1),
    sequence_server:register(2),
    ?assertEqual([1,2], sequence_server:get()).

should_return_largest_sequence_so_far() ->
    sequence_server:register(1),
    sequence_server:register(2),
    sequence_server:register(3),
    sequence_server:register(1),
    sequence_server:register(2),
    ?assertEqual([1,2,3], sequence_server:get()).

should_allow_to_reconfigure_itself() ->
    ?assertMatch(ok, sequence_server:set_conf([{max_sequences, 5}])).

should_configure_max_sequences() ->
    ok = sequence_server:set_conf([{max_sequences, 5}]),
    sequence_server:register(2),
    sequence_server:register(1),
    ok. % WIP
%    ?assertEqual([[1], [2]], sequence_server:get_multi()).

multi_server_should_return_empty_list_on_no_sequences() ->
    ?assertEqual([], sequence_server:get_multi()).

multi_server_should_return_single_sequence_when_only_one_sequence() ->
    sequence_server:register(1),
    ?assertEqual([[1]], sequence_server:get_multi()).

multi_server_should_return_two_sequence_when_both_present() ->
    sequence_server:register(2),
    sequence_server:register(3),
    sequence_server:register(1),
    ?assertEqual([[2,3],[1]], sequence_server:get_multi()).

multi_server_should_handle_largest_sequence_correctly() ->
    sequence_server:register(10),
    sequence_server:register(11),
    sequence_server:register(12),
    sequence_server:register(1),
    sequence_server:register(2),
    sequence_server:register(3),
    ?assertEqual([[1,2,3],[10,11,12]], sequence_server:get_multi()).

multi_server_should_register_subsequences() ->
    sequence_server:register(1),
    sequence_server:register(2),
    ?assertEqual([[1,2], [1]], sequence_server:get_multi()).
