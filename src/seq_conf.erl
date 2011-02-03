-module(seq_conf).
-export([load/1, get_env/3]).

-type path() :: string().
-type config() :: [config_item()].
-type config_item() :: {term(), term()}.


%% loads configuration from file
-spec load(path()) -> config().
load(Path) ->
    {ok, [H]} = file:consult(Path),
    H.

%% reads a configuration parameter from a config
-spec get_env(config(), atom(), term()) -> term().
get_env(Config, Key, DefaultValue) ->
    proplists:get_value(Key, Config, DefaultValue).
