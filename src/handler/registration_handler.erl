-module(registration_handler).
-export([signup/2,login/2]).

%% Helpes
-import(helper, [get_body/2]).
-import(response_helper,[]).
-import(user,[save_user/1,user_login/1]).

signup(Req, State)->
    {ok, Body, Req1} = cowboy_req:read_urlencoded_body(Req),
    {ok,UserAdded } = case get_body(Body, Req1) of
        {ok, Data} -> save_user(Data);
        {error, empty, _Req2} -> {ok, <<"Invalid user data">>}
    end,
    response_helper:success(Req, UserAdded , State).

login(Req, State)->
    {ok, Body, Req1} = cowboy_req:read_urlencoded_body(Req),
    ReqUserData = case get_body(Body, Req1) of
        {ok, Data} ->  Data;
        {error, empty, _Req2} -> io:fwrite("Error")
    end,
    {ok, UserData} = user_login(ReqUserData),
    response_helper:success(Req, UserData  , State).