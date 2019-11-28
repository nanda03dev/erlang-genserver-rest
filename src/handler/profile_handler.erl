-module(profile_handler).
-export([get_user_data/2]).

%% Helpes
-import(helper, [get_body/2]).
-import(response_helper,[]).
-import(user,[get_user/1]).

get_user_data(Req, State)->
  {ok, Body, Req1} = cowboy_req:read_urlencoded_body(Req),
  ReqUserData = case get_body(Body, Req1) of
                  {ok, Data} ->  Data;
                  {error, empty, _Req2} -> io:fwrite("Error")
                end,
  UserData = get_user(ReqUserData),
  response_helper:success(Req, UserData  , State).