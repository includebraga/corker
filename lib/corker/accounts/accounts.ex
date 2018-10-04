defmodule Corker.Accounts do
  import Ecto.Query, warn: false

  alias Corker.Accounts.User
  alias Corker.Repo

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
