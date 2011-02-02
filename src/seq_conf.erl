-module(seq_conf).
-export([load/1]).

-type path() :: string().
-type config() :: [config_item()].
-type config_item() :: {term(), term()}.
-spec load(path()) -> config().
load(Path) ->
    {ok, [H]} = file:consult(Path),
    H.
