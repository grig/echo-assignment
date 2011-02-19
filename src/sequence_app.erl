-module(sequence_app).

% Main application module
%
% Use start/0 to launch application with default settings
%
% Use start/1 to launch application configured according to parameters
% read from a configuration file.

-behaviour(application).

% application callbacks
-export([start/2, stop/1]).

% API
-export([start/0, start/1]).

%% Callbacks
start(_Type, _Args) ->
    {ok, Port} = application:get_env(?MODULE, port),
    {ok, MaxSequences} = application:get_env(?MODULE, max_sequences),
    error_logger:info_msg("sequence_app starting on port ~p, max_sequences=~p~n", [Port, MaxSequences]),
    seq_yaws:start(Port),
    sequence_sup:start_link(MaxSequences).

stop(_State) ->
    ok.

%% API
start() ->
    application:set_env(?MODULE, port, 8081),
    application:set_env(?MODULE, max_sequences, 1),
    application:start(sequence_app).

start(ConfigFile) ->
    Config = seq_conf:load(ConfigFile),
    Port = seq_conf:get_env(Config, port, 8081),
    MaxSequences = seq_conf:get_env(Config, max_sequences, 1),
    application:set_env(?MODULE, port, Port),
    application:set_env(?MODULE, max_sequences, MaxSequences),
    application:set_env(sequence_app, configFile, ConfigFile),
    application:start(sequence_app).

