-module(seq_conf_tests).
-include_lib("eunit/include/eunit.hrl").

load_config_test() ->
    save_config("tmp/sequence_server.config", "[{max_sequences, 5}]."),
    ?assertMatch([{max_sequences, 5}], seq_conf:load("tmp/sequence_server.config")).

save_config(Filename, Contents) ->
    ok = file:write_file(Filename, Contents).
