-module(sequence_server).
-compile(export_all).
-behaviour(gen_server).

% gen_server exports
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

% API
start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

-spec(stop() -> ok).
stop() ->
    gen_server:call(?MODULE, stop).

-spec(register(integer()) -> ok).
register(Val) ->
    gen_server:call(?MODULE, {register, Val}).

-spec(get() -> [integer()]).
get() ->
    gen_server:call(?MODULE, get).

% gen_server callbacks
init(_Arg) ->
    {ok, {sequence_new(), sequence_new()}}.

handle_call({register, Num}, _From, { Longest, Current }) ->
    {reply, ok, update_state(Num, {Longest, Current})};
handle_call(get, _From, State = { Longest, Current }) ->
    {reply, sequence_to_list(Longest), State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

update_state(Num, {Longest, Current}) ->
    Current1 = sequence_update(Num, Current),
    Longest1 = case sequence_length(Longest) =< sequence_length(Current1) of
                   true -> Current1;
                   _ -> Longest
               end,
    {Longest1, Current1}.

sequence_new() -> [].

sequence_length(Seq) -> length(Seq).

sequence_update(Num, []) -> [Num];
sequence_update(Num, L = [H|_T]) when Num > H -> [Num | L];
sequence_update(Num, [H|_T]) when Num =< H -> [Num].

sequence_to_list(Seq) ->
    lists:reverse(Seq).

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
