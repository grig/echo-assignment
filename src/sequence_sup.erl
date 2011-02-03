-module(sequence_sup).
% Supervisor controlling both yaws and sequence server itself

-behaviour(supervisor).

% API
-export([start_link/2]).

% supervisor callbacks
-export([init/1]).

start_link(Port, MaxSequences) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, {Port, MaxSequences}).

% Supervisor callbacks
init({Port, MaxSequences}) ->
    {ok, {{one_for_one, 1, 60},
          [{seq_yaws_sup, {seq_yaws_sup, start_link, [Port]},
            permanent, infinity, supervisor,
            [seq_yaws_sup]},
           {sequence_server_sup, {sequence_server_sup, start_link, [[{max_sequences, MaxSequences}]]},
            permanent, infinity, supervisor,
            [sequence_server_sup]}]}}.

