%%%-------------------------------------------------------------------
%%% @author nandakumar
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Nov 2019 6:07 PM
%%%-------------------------------------------------------------------
-module(server_app).
-author("nandakumar").

%% API
-export([start_server/0]).

start_server()->
      Dispatch = cowboy_router:compile([
        {'_', [
            {"/profile/[...]", profile_router, []},
            {"/reg/[...]", registration_router, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch},
            middlewares => [cowboy_router, cowboy_handler]
    }),
  io:fwrite("Start server called ").