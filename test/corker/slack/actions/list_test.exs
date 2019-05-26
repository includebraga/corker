defmodule Corker.Slack.Actions.WeeklyListTest do
  use Corker.DataCase, async: true

  alias Corker.Slack.Actions

  describe "run/1" do
    test "ignores if the command is invalid" do
      assert nil == Actions.WeeklyList.run(%{text: "just a command", user: "123"})
    end

    test "returns a message with the reasons from this week's high fives" do
      receiver = insert(:user)
      high_fives = insert_list(2, :high_five, receiver_id: receiver.id)

      {:reply, reply} =
        Actions.WeeklyList.run(%{text: "list my high fives", user: receiver.slack_id})

      for high_five <- high_fives do
        assert String.contains?(reply, high_five.reason)
      end
    end

    test "ignores old high fives" do
      receiver = insert(:user)
      two_weeks_ago = Timex.now() |> Timex.shift(weeks: -2)
      new_high_five = insert(:high_five, receiver_id: receiver.id)

      old_high_five =
        insert(:high_five, receiver_id: receiver.id, inserted_at: two_weeks_ago)

      {:reply, reply} =
        Actions.WeeklyList.run(%{text: "list my high fives", user: receiver.slack_id})

      assert String.contains?(reply, new_high_five.reason)
      refute String.contains?(reply, old_high_five.reason)
    end

    test "ignores other user's high fives" do
      user = insert(:user)
      another_user = insert(:user)
      user_high_five = insert(:high_five, receiver_id: user.id)
      other_high_five = insert(:high_five, receiver_id: another_user.id)

      {:reply, reply} =
        Actions.WeeklyList.run(%{text: "list my high fives", user: user.slack_id})

      assert String.contains?(reply, user_high_five.reason)
      refute String.contains?(reply, other_high_five.reason)
    end
  end
end
