-module(sequence_server_sup).
-behavior(supervisor).

-export([start_link/1]).
-export([init/1]).

% API

start_link(Args) ->
    supervisor:start_link(?MODULE, Args).

% Supervisor callbacks
init(Args) ->
    {ok, {{one_for_one, 1, 60},
          [{sequence_server,
            {sequence_server, start_link, [Args]},
            permanent, brutal_kill, worker,
            [sequence_server]}]}}.
