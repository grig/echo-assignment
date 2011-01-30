-module(sequence_server_tests).
-include_lib("eunit/include/eunit.hrl").

put_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
     [fun should_register_value/0,
      fun should_return_empty_list_on_empty_sequence/0,
      fun should_return_single_element/0,
      fun should_return_sequential_elements/0,
      fun should_reset_sequence_for_out_of_order_elements/0,
      fun should_return_largest_sequence_so_far/0,
      sequence
     ]}.

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
