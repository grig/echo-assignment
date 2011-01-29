-module(sequence_tests).
-include_lib("eunit/include/eunit.hrl").

-define(assertSeqEqual(List, Seq),
        ?assertEqual(length(List), sequence:length(Seq)),
        ?assertEqual(List, sequence:to_list(Seq))).

-define(assertSeqEqual_(List, Seq),
        fun() -> ?assertSeqEqual(List, Seq) end).

sequence_test_() ->
    [{"new seq should be empty",
      ?assertSeqEqual_([], seq([]))},
     {"insert of element into empty seq should increment seq",
      ?assertSeqEqual_([1], seq([1]))},
     {"insert of larger element should increase seq",
      ?assertSeqEqual_([1,2,3], seq([1,2,3]))},
     {"insert of smaller element should reset seq",
      ?assertSeqEqual_([1,2], seq([2,1,2]))}].

% inserts elements of L into an empty sequence and returns resulting sequence
seq(L) ->
    lists:foldl(fun sequence:insert/2, sequence:new(), L).
