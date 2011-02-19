-module(sequence_sup).
% Supervisor controlling both yaws and sequence server itself

-behaviour(supervisor).

% API
-export([start_link/1]).

% supervisor callbacks
-export([init/1]).

start_link(MaxSequences) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, {MaxSequences}).

% Supervisor callbacks
init({MaxSequences}) ->
    {ok, {{one_for_one, 1, 60},
          [{sequence_server,
            {sequence_server, start_link, [[{max_sequences, MaxSequences}]]},
            permanent, brutal_kill, worker,
            [sequence_server]}]}}.
