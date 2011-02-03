-module(seq_appmod).
-include("yaws_api.hrl").
-export([out/1]).

out(A) ->
    case A#arg.appmoddata of
        "put" -> handle_put(A);
        "get" -> handle_get(A);
        _     -> handle_not_found()
    end.

% handles requests to "/put" URIs
handle_put(A) ->
    case decode_request(A) of
        {ok, _Val} ->
            sequence_server:register(_Val),
            [{status, 204}];
        _          -> [{status, 400}]
    end.

decode_request(A) ->
    case content_type(A) of
        "text/plain" ->
             decode_input(A#arg.clidata);
        _ -> error
    end.

content_type(A) ->
    Headers = A#arg.headers,
    Headers#headers.content_type.

-spec decode_input(binary()) -> {ok, integer()} | error.
decode_input(Data) ->
    try list_to_integer(binary_to_list(Data)) of
        Val -> {ok, Val}
    catch
        error:badarg -> error
    end.

% handles requests to "/get" URI
handle_get(_A) ->
    [{status, 200},
     {html,
      io_lib:format("~p", [sequence_server:get_sequences()])}].

% handles other requests
handle_not_found() ->
    [{status, 404},
     {html, "Not Found"}].
