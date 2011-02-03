-module(sequence_server).
-compile(export_all).
-behaviour(gen_server).

% gen_server exports
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, 1, []).

-spec start_link(config()) -> ok.
start_link([{max_sequences, N}]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, N, []).

-spec(stop() -> ok).
stop() ->
    gen_server:call(?MODULE, stop).

-spec(register(integer()) -> ok).
register(Val) ->
    gen_server:call(?MODULE, {register, Val}).

-spec(get() -> [integer()]).
get() ->
    gen_server:call(?MODULE, get).

get_multi() ->
    gen_server:call(?MODULE, get_multi).

-spec(set_conf(config()) -> ok).
-type config() :: [config_item()].
-type config_item() :: {atom(), term()}.
%% Reconfigures sequence_server using given configuration
%% TODO: graceful reconfigurations
set_conf(Config) ->
    stop(),
    start_link(Config),
    ok.

% gen_server callbacks
init(MaxSequences) ->
    {ok, {seq_cache:new(MaxSequences), sequence:new()}}.

handle_call({register, Num}, _From, State) ->
    {reply, ok, update_state(Num, State)};
handle_call(get, _From, State = { Sequences, _Current }) ->
    Longest = case seq_cache:values(Sequences) of
                  [] -> [];
                  [H|_T] -> H
              end,
    {reply, Longest, State};
handle_call(get_multi, _From, State = { Sequences, _Current }) ->
    SequenceLists = seq_cache:values(Sequences),
    {reply, SequenceLists, State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

update_state(Num, {Sequences, Current}) ->
    Current1 = sequence:insert(Num, Current),
    Sequences1 = seq_cache:insert(Sequences, Current1),
    {Sequences1, Current1}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
