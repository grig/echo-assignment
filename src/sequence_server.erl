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

update_longest_sequences({Longest, NextLongest}, Current) ->
    case sequence:length(Current) >= sequence:length(Longest) of
        true -> {Current, Longest};
        _ -> case sequence:length(Current) >= sequence:length(NextLongest) of
                 true -> { Longest, Current};
                 _ -> { Longest, NextLongest}
             end
    end.

sequences_to_list({Longest, NextLongest}) ->
    case {Longest, NextLongest} of
        {[], []}  -> [];
        {Seq, []} -> [sequence:to_list(Seq)];
        {Seq, Seq2} -> [sequence:to_list(Seq), sequence:to_list(Seq2)]
    end.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
