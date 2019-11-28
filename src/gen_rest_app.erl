%%%-------------------------------------------------------------------
%% @doc gen_rest public API
%% @end
%%%-------------------------------------------------------------------

-module(gen_rest_app).

-behaviour(application).

-export([start/2, stop/1,start/0]).

start()->
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
%%    Dispatch = cowboy_router:compile([
%%        {'_', [
%%            {"/profile/[...]", profile_router, []},
%%            {"/reg/[...]", registration_router, []}
%%        ]}
%%    ]),
%%    {ok, _} = cowboy:start_clear(my_http_listener,
%%        [{port, 8080}],
%%        #{env => #{dispatch => Dispatch},
%%            middlewares => [cowboy_router, cowboy_handler]
%%    }),
    gen_rest_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
