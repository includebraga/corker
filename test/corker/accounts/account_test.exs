defmodule Corker.AccountsTest do
  use Corker.DataCase, async: true
  doctest Corker.Accounts

  alias Corker.{
    Accounts,
    Accounts.User,
    Repo
  }

  describe "create_user/1" do
    test "inserts a new user if the data is valid" do
      params = params_for(:user)

      Accounts.create_user(params)

      assert Repo.aggregate(User, :count, :id) == 1
    end

    test "requires all fields" do
      params_without_slack_id = params_for(:user, slack_id: nil)
      params_without_username = params_for(:user, username: nil)

      Accounts.create_user(params_without_slack_id)
      Accounts.create_user(params_without_username)

      assert Repo.aggregate(User, :count, :id) == 0
    end

    test "fails if the user already exists" do
      user = insert(:user)
      params = params_for(:user, slack_id: user.slack_id)

      Accounts.create_user(params)

      assert Repo.aggregate(User, :count, :id) == 1
    end
  end
end
