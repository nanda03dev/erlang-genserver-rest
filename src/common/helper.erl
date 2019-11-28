-module(helper).

-export([get_body/2]).
-export([reply/3]).
-export([encode/1]).
-export([decode/2]).
-export([get_state/1]).
-export([random_string/1,authenticate_user/1]).

-import(user,[check_token/1]).
-import(response_helper,[unauthorized/2]).

get_state(State)->
    case length(State) of
    State when State > 0 -> lists:last(State);
    _-> no_state 
    end.

get_body(Body, Req) ->
    case Body of 
        [{Input, true}] ->
            {ok, decode(Input,Req)};
        [] ->
            {ok, #{}};
        _ ->
            {error, empty, reply(400, <<"Bad request">>, Req)}
    end.

decode(Input,Req)->
    try jiffy:decode(Input, [return_maps]) of
        Data -> Data
    catch
        _:_ -> {error, empty, reply(400, <<"Invalid json">>, Req)}
    end.

encode(Body)->
    jiffy:encode(Body).

reply(Code, Body, Req) ->
    cowboy_req:reply(Code, #{<<"content-type">> => <<"application/json">>},encode(Body), Req).

random_string(Len) ->
    Chars = list_to_tuple("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
    CharsSize = size(Chars),
    F = fun(_, R) -> [element(rand:uniform(CharsSize), Chars) | R] end,
    list_to_binary(lists:foldl(F, "", lists:seq(1, Len))).

authenticate_user(Req)->
    ReqToken = cowboy_req:header(<<"token">>,Req),
    check_token({ReqToken}).
