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
    {ok, []}.

handle_call(Request, _From, Seq) ->
    case Request of
        {register, Num} ->
            {reply, ok, update_sequence(Num, Seq)};
        get ->
            {reply, lists:reverse(Seq), Seq};
        stop ->
            {stop, normal, ok, Seq}
    end.

update_sequence(Num, []) -> [Num];
update_sequence(Num, L = [H|_T]) when Num > H -> [Num | L];
update_sequence(Num, [H|_T]) when Num =< H -> [Num].

handle_cast(_Request, Seq) ->
    {noreply, Seq}.

handle_info(_Info, Seq) ->
    {noreply, Seq}.

terminate(_Reason, _Seq) -> ok.

code_change(_OldVsn, Seq, _Extra) -> {ok, Seq}.
