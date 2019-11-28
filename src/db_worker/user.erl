%%%-------------------------------------------------------------------
%%% @author nandakumar
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Nov 2019 5:16 PM
%%%-------------------------------------------------------------------
-module(user).
-author("nandakumar").

%% API
-export([save_user/1,get_user/1,user_login/1,check_token/1]).
-import(helper,[random_string/1]).

save_user(UserData)->
  ReadResult = file:read_file("UserName.txt"),
  AllUserDataBinary  = case ReadResult of
                         {ok,_Data} ->    element(2,ReadResult);
                         {error, _} ->  <<>>
                       end,
  AllUserData = case AllUserDataBinary of
                  AllUserDataBinary when byte_size(AllUserDataBinary) > 0 -> binary_to_term(AllUserDataBinary);
                  _ -> #{<<"tokenlist">> =>[]}
                end,
  UserId = maps:size(AllUserData),
  NewUserId = string:concat("RB",integer_to_list(UserId)),
  NewToken = random_string(20),
  TokenList = maps:get(<<"tokenlist">>,AllUserData),
  UpdatedTokenList = lists:append(TokenList,[NewToken]),
  io:fwrite("~n New User Id ~p ",[NewUserId]),
  UpdatedUserData = maps:merge(UserData,#{<<"token">> =>NewToken,<<"Id">>=> list_to_binary(NewUserId) }),
  io:fwrite("~n Updated User Data ~p ",[UpdatedUserData]),
  UpdatedMap = maps:merge(AllUserData,#{<<"tokenlist">> => UpdatedTokenList, list_to_binary(NewUserId) => UpdatedUserData }),
  io:fwrite("~n Updated All Map~p ",[UpdatedMap]),

  {ok, Fd} = file:open("UserName.txt", [write]),
  file:write(Fd,[term_to_binary(UpdatedMap )]),
  io:fwrite("~n User added "),
  {ok, list_to_binary("New User Added Id "++NewUserId)}.


user_login(UserParams)->
  #{<<"password">> := Password } = UserParams,
  UserData = get_user(UserParams),
  ResponseData = case UserData of
    UserData when map_size(UserData) > 0 ->
      case check_password({Password,maps:get(<<"password">>,UserData,"")}) of
        true ->  #{id=> maps:get(<<"Id">>,UserData),token=> maps:get(<<"token">>,UserData)};
        _ -> <<"Mismatched username and password">>
      end;
    _ -> <<"User not found">>
  end,
  {ok, ResponseData}.


get_user(#{<<"id">> := Id })->
  {ok ,AllUserDataBinary } = file:read_file("UserName.txt"),
  AllUserData = binary_to_term(AllUserDataBinary),
  maps:get(Id,AllUserData,#{}).

check_password(PwdTuple)->
  element(1,PwdTuple) =:= element(2,PwdTuple).

check_token(TokenTuple)->
  Token = element(1,TokenTuple),
  {ok ,AllUserDataBinary } = file:read_file("UserName.txt"),
  AllUserData = binary_to_term(AllUserDataBinary),
  TokenList = maps:get(<<"tokenlist">>,AllUserData),
  case lists:search(fun(Each)-> Each =:= Token end, TokenList) of
   {_,Result } -> true;
   _ -> false
  end.