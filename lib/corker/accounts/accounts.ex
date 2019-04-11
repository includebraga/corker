defmodule Corker.Accounts do
  import Ecto.Query, warn: false

  alias Corker.Accounts.User
  alias Corker.Repo

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def exists_user?(username) do
    query = from u in User, where: u.username == ^username

    Repo.exists?(query)
  end

  def find_by(params), do: Repo.get_by(User, params)
end
