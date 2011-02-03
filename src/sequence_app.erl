-module(sequence_app).
-behaviour(application).

% application callbacks
-export([start/2, stop/1]).

% API
-export([start/0, start/1]).

start(_Type, _Args) ->
    {ok, ConfigFile} = application:get_env(?MODULE, configFile),
    io:format("config: ~p~n", [ConfigFile]),
    start_sup(ConfigFile).

start() ->
    application:start(sequence_app).

start(ConfigFile) ->
    application:set_env(sequence_app, configFile, ConfigFile),
    application:start(sequence_app).

start_sup(ConfigFile) ->
    Config = seq_conf:load(ConfigFile),
    Port = seq_conf:get_env(Config, port, 8081),
    MaxSequences = seq_conf:get_env(Config, max_sequences, 1),
    sequence_sup:start_link(Port, MaxSequences).
%    start(Port, MaxSequences).

stop(_State) ->
    ok.
