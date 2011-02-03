-module(seq_conf_tests).
-include_lib("eunit/include/eunit.hrl").

load_config_test() ->
    save_config("tmp/sequence_server.config", "[{max_sequences, 5}]."),
    ?assertMatch([{max_sequences, 5}], seq_conf:load("tmp/sequence_server.config")).

get_config_value_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
     [ fun should_read_existing_strings/0,
       fun should_read_existing_atoms/0,
       fun should_return_default_value_on_missing_keys/0
     ]}.

setup() ->
    save_config("tmp/sequence_server.config", "[{foo, \"bar\"}, {fred, barney}].").
cleanup(_) ->
    ok = file:delete("tmp/sequence_server.config").
save_config(Filename, Contents) ->
    ok = file:write_file(Filename, Contents).

should_read_existing_strings() ->
    Config = seq_conf:load("tmp/sequence_server.config"),
    ?assertMatch("bar", seq_conf:get_env(Config, foo, undefined)).

should_read_existing_atoms() ->
    Config = seq_conf:load("tmp/sequence_server.config"),
    ?assertMatch(barney, seq_conf:get_env(Config, fred, undefined)).

should_return_default_value_on_missing_keys() ->
    Config = seq_conf:load("tmp/sequence_server.config"),
    ?assertMatch(betty, seq_conf:get_env(Config, wilma, betty)).
