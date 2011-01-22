-module(sg_appmod).
-include("/Users/grig/local/yaws/lib/yaws/include/yaws_api.hrl").
-export([out/1]).

out(A) ->
    case A#arg.appmoddata of
        "put" -> put(A);
        _      -> not_found()
    end.

put(A) ->
    case decode_input(A#arg.clidata) of
        {ok, Val} -> [{status, 204}];
        _         -> [{status, 400}]
    end.

% @spec decode_input(binary()) -> {ok, integer()} | error.
decode_input(Data) ->
    try list_to_integer(binary_to_list(Data)) of
        Val -> {ok, Val}
    catch
        error:badarg -> error
    end.

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
