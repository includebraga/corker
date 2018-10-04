defmodule Corker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:slack_id, :username]

  schema "users" do
    field :slack_id, :string
    field :username, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint(:slack_id)
  end
end
