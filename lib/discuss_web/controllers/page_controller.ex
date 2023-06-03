defmodule DiscussWeb.PageController do
  use DiscussWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
