defmodule Corker.Services.ExtractUsersTest do
  use Corker.DataCase, async: true
  doctest Corker.Services.ExtractUsers

  alias Corker.{
    Accounts.User,
    Repo,
    Services.ExtractUsers
  }

  describe "perform/1" do
    test "creates a user for each slack user in the list" do
      slack_users = build_list(5, :slack_user) |> Enum.into(%{}, &{&1.id, &1})

      ExtractUsers.perform(slack_users)

      assert Repo.aggregate(User, :count, :id) == 5
    end

    test "ignores repeated users" do
      user = insert(:user)
      repeated_user = build(:slack_user, id: user.slack_id)

      slack_users =
        build_list(4, :slack_user)
        |> Enum.into(%{}, &{&1.id, &1})
        |> Map.merge(%{repeated_user.id => repeated_user})

      ExtractUsers.perform(slack_users)

      assert Repo.aggregate(User, :count, :id) == 5
    end
  end
end
