-module(sequence_server).
-compile(export_all).
-behaviour(gen_server).

% gen_server exports
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, 2, []).

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
set_conf(_Config) ->
    ok.

% gen_server callbacks
init(MaxSequences) ->
    {ok, {sequences_new(MaxSequences), sequence:new()}}.

handle_call({register, Num}, _From, State) ->
    {reply, ok, update_state(Num, State)};
handle_call(get, _From, State = { Sequences, _Current }) ->
    Longest = case sequences_to_list(Sequences) of
                  [] -> [];
                  [H|_T] -> H
              end,
    {reply, Longest, State};
handle_call(get_multi, _From, State = { Sequences, _Current }) ->
    SequenceLists = sequences_to_list(Sequences),
    {reply, SequenceLists, State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

update_state(Num, {Sequences, Current}) ->
    Current1 = sequence:insert(Num, Current),
    Sequences1 = update_longest_sequences(Sequences, Current1),
    {Sequences1, Current1}.

sequences_new(N) ->
    list_to_tuple(sequences_new1(N)).

sequences_new1(0) -> [];
sequences_new1(N) -> [sequence:new() | sequences_new1(N - 1) ].


update_longest_sequences(Sequences, Current) ->
    L = tuple_to_list(Sequences),
    L1 = update_longest_sequences1(L, Current),
    list_to_tuple(L1).

update_longest_sequences1([], _Current) -> [];
update_longest_sequences1(L = [H|T], Current) ->
    case sequence:length(Current) >= sequence:length(H) of
        true -> [ Current | chomp(L)];
        _ -> [ H | update_longest_sequences1(T, Current)]
    end.

chomp(L) -> lists:sublist(L, length(L) - 1).

sequences_to_list(S) ->
    L = tuple_to_list(S),
    lists:map(fun sequence:to_list/1, lists:filter(fun(X) -> X =/= [] end, L)).

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
