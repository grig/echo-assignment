-module(sequence_server).
-behaviour(gen_server).

% gen_server exports
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

% API
-export([start_link/1, stop/0, get_sequences/0, register/1, set_conf/1]).

%% starts the server with a given configuration
-spec start_link(config()) -> ok.
start_link([{max_sequences, N}]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, N, []).

%% stops the server
-spec(stop() -> ok).
stop() ->
    gen_server:call(?MODULE, stop).

%% registers a new value
-spec(register(integer()) -> ok).
register(Val) ->
    gen_server:call(?MODULE, {register, Val}).

%% returns contents of current sequence cache
-spec get_sequences() -> [[integer()]].
get_sequences() ->
    gen_server:call(?MODULE, get_sequences).

%% Reconfigures sequence_server using given configuration
%% TODO: graceful reconfigurations
-spec(set_conf(config()) -> ok).
-type config() :: [config_item()].
-type config_item() :: {atom(), term()}.
set_conf(Config) ->
    gen_server:call(?MODULE, {set_conf, Config}).

% gen_server callbacks
init(MaxSequences) ->
    {ok, {seq_cache:new(MaxSequences), sequence:new()}}.

handle_call({register, Num}, _From, {Sequences, Current}) ->
    Current1 = sequence:insert(Num, Current),
    Sequences1 = seq_cache:insert(Sequences, Current1),
    {reply, ok, {Sequences1, Current1}};
handle_call(get_sequences, _From, State = { Sequences, _Current }) ->
    {reply, seq_cache:values(Sequences), State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State};
handle_call({set_conf, [{max_sequences, MaxSequences}]}, _From, _State) ->
    State = {seq_cache:new(MaxSequences), sequence:new()},
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
