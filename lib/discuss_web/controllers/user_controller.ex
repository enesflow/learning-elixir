defmodule DiscussWeb.UserController do
  use DiscussWeb, :controller

  def show(conn, %{"id" => id}) do
    Identicon.main(id)
    path = Application.app_dir(:discuss, "../../../../#{id}.png")

    conn
    |> put_resp_content_type("image/png")
    |> send_file(200, path)
  end
end
