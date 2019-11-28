-module(request_parser).

%%Rest Callbacks
-export([r_init/2]).

-export([r_allowed_methods/2]).

-export([r_content_types_provided/3]).

-export([r_content_types_accepted/3]).

-export([r_resource_exists/2]).

r_init(Req, State) ->
    % io:fwrite("~n Init"),
    {cowboy_rest, Req, State}.

r_allowed_methods(Req, State) ->
    % io:fwrite("~n Methods"),
    {[<<"GET">>, <<"POST">>], Req, State}.

r_content_types_provided(Req, State, router) ->
    % io:fwrite("~n Provider ~p ",[router]),
    {[{<<"application/json">>, router}], Req, State}.

r_content_types_accepted(Req, State, router) ->
    % io:fwrite("~n accepedted...."),
    {[{<<"application/json">>, router}], Req, State}.

r_resource_exists(Req, State) -> {true, Req, State}.
