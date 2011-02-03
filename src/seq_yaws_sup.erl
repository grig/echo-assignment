-module(seq_yaws_sup).
% supervisor for embedded yaws instance
-behaviour(supervisor).

% API
-export([start_link/1]).

% supervisor callbacks
-export([init/1]).

start_link(Port) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Port]).

init(Args) ->
    {ok, {{one_for_all, 0, 1},
          [{seq_yaws, {seq_yaws, start, Args},
           permanent, 2000, worker, [seq_yaws]}]}}.
