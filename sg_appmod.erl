-module(sg_appmod).
-include("/Users/grig/local/yaws/lib/yaws/include/yaws_api.hrl").
-export([out/1]).

out(A) ->
    case A#arg.appmoddata of
        "put" -> handle_put(A);
        _     -> handle_not_found()
    end.

handle_put(A) ->
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

handle_not_found() ->
    [{status, 404},
     {html, "Not Found"}].
