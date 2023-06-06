defmodule Discuss.Plug.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    # Don't forget that the _params argument is not the normal params
    #  It it the params passed from the init function
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      #  if we redirect to /auth/github, then the put_flash message will be lost
      # so we will redirect to /topics instead
      |> redirect(to: "/topics")
      #  halt means that the connection will stop here
      |> halt()
    end
  end
end
