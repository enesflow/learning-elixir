defmodule Discuss.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      provider: Atom.to_string(auth.provider),
      email: auth.info.email
    }

    changeset = User.changeset(%User{}, user_params)

    # insert_or_get_user(changeset)
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Signed out")
    |> redirect(to: ~p"/topics")
  end

  defp signin(conn, changeset) do
    case insert_or_get_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/topics")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: ~p"/topics")
    end
  end

  defp insert_or_get_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
