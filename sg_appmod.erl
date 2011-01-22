-module(sg_appmod).
-include("/Users/grig/local/yaws/lib/yaws/include/yaws_api.hrl").
-export([out/1]).

out(A) ->
    [{status, 204},
     {ehtml,
      [{p, [], {pre, [], io_lib:format("A#arg.appmoddata = ~p~n"
                                       "A#arg.appmod_prepath = ~p~n"
                                       "A#arg.querydata = ~p~n",
                                       [A#arg.appmoddata,
                                        A#arg.appmod_prepath,
                                        A#arg.querydata])}}]}].
