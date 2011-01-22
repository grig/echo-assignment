-module(sg_appmod).
-include("/Users/grig/local/yaws/lib/yaws/include/yaws_api.hrl").
-export([out/1]).

out(A) ->
    case A#arg.appmoddata of
        "put" -> put(A);
        _      -> not_found()
    end.

put(A) ->
    [{status, 204}].

info(A) ->
    [{ehtml,
      [{p, [], {pre, [], io_lib:format("A#arg.appmoddata = ~p~n"
                                       "A#arg.appmod_prepath = ~p~n"
                                       "A#arg.querydata = ~p~n",
                                       [A#arg.appmoddata,
                                        A#arg.appmod_prepath,
                                        A#arg.querydata])}}]}].

not_found() ->
    [{status, 404},
     {html, "Not Found"}].
