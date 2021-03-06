-module(boss_db_sup).
-author('emmiller@gmail.com').

-behaviour(supervisor).

-export([start_link/0, start_link/1]).

-export([init/1]).

start_link() ->
    start_link([]).

start_link(StartArgs) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, StartArgs).

init(StartArgs) ->

    AppName = application:get_application(),

    Args = [{name, {local, boss_db_pool}},
            {worker_module, boss_db_controller},
            {size, application:get_env(AppName, db_pool_size, 5)},
            {max_overflow, application:get_env(AppName, db_pool_max_overflow, 10)}|StartArgs],
    PoolSpec = {db_controller, {poolboy, start_link, [Args]}, permanent, 2000, worker, [poolboy]},
    {ok, {{one_for_one, 10, 10}, [PoolSpec]}}.
