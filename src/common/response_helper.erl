-module(response_helper).
-import(helper,[encode/1]).
-export([success/3,bad_request/3,internal_server_error/3,not_found/3,unauthorized/1]).

success(Req,Body,State)->
    {true, reply(Req, #{code=> 200, data=>Body}), State }.

bad_request(Req,Body,State)->
    {false, reply(Req, #{code=> 400, error=>Body}) , State }.

internal_server_error(Req,Body,State)->
    {false, reply(Req,#{code=> 500, error=>Body}), State }.

not_found(Req,Body,State)->
    {false, reply(Req, #{code=> 404, error=>Body}), State }.

unauthorized(Req)->
    {false, reply(Req, #{code => 401, error=><<"Unauthorized user">>}) , #{} }.

reply(Req,Body)->
    cowboy_req:set_resp_body(encode(Body), Req).