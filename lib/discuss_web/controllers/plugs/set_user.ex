defmodule Discuss.Plug.SetUser do
  import Plug.Conn

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
    #  nothing to do here
  end

  def call(conn, _params) do
    #  The _params here are not the same as the params in controllers
    #  It is the data passed from the init function
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
