defmodule Discuss.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> custom_validation()
  end

  # Make sure title is not "123"
  def custom_validation(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{title: "123"}} ->
        changeset
        |> add_error(:title, "cannot be 123")

      _ ->
        changeset
    end
  end
end
