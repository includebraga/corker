defmodule Corker.Factory do
  use ExMachina.Ecto, repo: Corker.Repo

  alias Corker.Accounts.User

  def user_factory do
    %User{
      slack_id: Faker.String.base64(),
      username: Faker.Internet.user_name()
    }
  end
end
