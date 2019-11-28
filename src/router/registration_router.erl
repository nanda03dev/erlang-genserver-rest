-module(registration_router).
-behavior(cowboy_rest).

%%Rest Callbacks
-export([init/2,allowed_methods/2,content_types_provided/2,content_types_accepted/2,resource_exists/2]).
-export([router/2]).

%%import modules
-import(helper, [ get_state/1]).
-import(request_parser, [r_init/2, r_allowed_methods/2,r_content_types_provided/3,r_content_types_accepted/3,r_resource_exists/2] ).
-import(registration_handler,[]).
-import(response_helper,[]).

init(Req, State) -> r_init(Req,State).
allowed_methods(Req, State)-> r_allowed_methods(Req, State).
content_types_provided(Req, State)-> r_content_types_provided(Req, State,router).
content_types_accepted(Req, State)-> r_content_types_accepted(Req, State,router).
resource_exists(Req, State)-> r_resource_exists(Req, State).

router(Req, State) ->
    % ReqState = get_state(State),
    % io:fwrite("~n Request ~p ",[Req] ),
    Path = cowboy_req:path(Req),
    PathAtom = binary_to_atom(Path,latin1),
    case PathAtom of
        '/reg/signup' -> registration_handler: signup(Req,State);
        '/reg/login' -> registration_handler: login(Req,State);
        _ -> response_helper:not_found(Req, <<"Not found">>,State)
    end.
