defmodule Corker.Slack.UsersTest do
  use Corker.DataCase, async: true
  doctest Corker.Slack.Users

  alias Corker.{
    Accounts.User,
    Repo,
    Slack.Users
  }

  describe "perform/1" do
    test "creates a user for each slack user in the list" do
      slack_users = build_list(5, :slack_user) |> Enum.into(%{}, &{&1.id, &1})

      Users.perform(slack_users)

      assert Repo.aggregate(User, :count, :id) == 5
    end

    test "ignores repeated users" do
      user = insert(:user)
      repeated_user = build(:slack_user, id: user.slack_id)

      slack_users =
        build_list(4, :slack_user)
        |> Enum.into(%{}, &{&1.id, &1})
        |> Map.merge(%{repeated_user.id => repeated_user})

      Users.perform(slack_users)

      assert Repo.aggregate(User, :count, :id) == 5
    end

    test "ignores bot and app users" do
      %{id: slack_id, name: username} = real_user = build(:slack_user)

      slack_users =
        Enum.into(
          [
            real_user,
            build(:slack_app_user),
            build(:slack_bot_user),
            build(:slackbot)
          ],
          %{},
          &{&1.id, &1}
        )

      Users.perform(slack_users)

      assert [%User{slack_id: ^slack_id, username: ^username}] = Repo.all(User)
    end
  end
end
