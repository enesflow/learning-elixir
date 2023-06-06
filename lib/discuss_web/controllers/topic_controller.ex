defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic

  import Ecto
  alias Discuss.Repo

  plug Discuss.Plug.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    #  topics = Topics.list_topics()
    topics = Repo.all(Topic)
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    # changeset = Topics.change_topic(%Topic{})
    changeset = Topic.changeset(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    # {status, changeset} = Topics.create_topic(topic_params)
    changeset =
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic_params)

    # build_assoc kinda works like this,
    #  the first parameter is the thing you want to associate with
    #  the second parameter is the thing you want to build
    #  build_assoc looks at the first parameter and uses it to build...
    # somewhat of a boilerplate or template for the second parameter
    # so in this case, we're building a topic, and we're using the user
    # to build it, so the topic will have the user's id
    #  Then we pass the topic_params to the changeset function and fill in the rest
    #  It's that simple!
    #  An example of this would be:
    # user = conn.assigns.user --> %User{id: 1}
    #  changeset = build_assoc(user, :topics) --> %Topic{user_id: 1, #Rest is nil}
    # Topic.changeset(changeset, topic_params) --> %Topic{user_id: 1, #Rest is filled in with topic_params}
    #  This is a very powerful function, and it's very useful for creating associations

    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # topic = Topics.get_topic!(id)
    topic = Repo.get!(Topic, id)
    render(conn, :show, topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    # topic = Topics.get_topic!(id)
    # changeset = Topics.change_topic(topic)
    topic = Repo.get!(Topic, id)
    changeset = Topic.changeset(topic)
    render(conn, :edit, topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    # topic = Topics.get_topic!(id)
    topic = Repo.get!(Topic, id)

    case topic |> Topic.changeset(topic_params) |> Repo.update() do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # topic = Topics.get_topic!(id)
    # {:ok, _topic} = Topics.delete_topic(topic)
    topic = Repo.get!(Topic, id)
    Repo.delete(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: ~p"/topics")
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Repo.get!(Topic, id).user_id != conn.assigns.user.id do
      conn
      |> put_flash(
        :error,
        "You are not the owner of this topic. Please stop trying to hack the site."
      )
      |> redirect(to: ~p"/topics/#{id}")
      |> halt()
    else
      conn
    end
  end
end
