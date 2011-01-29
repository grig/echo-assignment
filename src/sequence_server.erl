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
    {ok, {[], []}}.

handle_call({register, Num}, _From, { Longest, Current }) ->
    {reply, ok, update_state(Num, {Longest, Current})};
handle_call(get, _From, State = { Longest, Current }) ->
    {reply, lists:reverse(Longest), State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

update_state(Num, {Longest, Current}) ->
    Current1 = update_sequence(Num, Current),
    Longest1 = case sequence_length(Longest) =< sequence_length(Current1) of
                   true -> Current1;
                   _ -> Longest
               end,
    {Longest1, Current1}.

sequence_length(Seq) -> length(Seq).

update_sequence(Num, []) -> [Num];
update_sequence(Num, L = [H|_T]) when Num > H -> [Num | L];
update_sequence(Num, [H|_T]) when Num =< H -> [Num].

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.
