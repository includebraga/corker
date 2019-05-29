defmodule Corker.Slack.Actions.MonthlyStatsTest do
  use Corker.DataCase, async: true

  alias Corker.Slack.Actions

  describe "run/1" do
    test "ignores if the command is invalid" do
      assert nil ==
               Actions.WeeklyList.run(%{text: "just a command", user: "123"})
    end

    test "returns a message with the leaderboard for this month" do
      top_sender = insert(:user)
      top_receiver = insert(:user)
      avg_user = insert(:user)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: top_sender.id)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: avg_user.id)
      insert(:high_five, receiver_id: avg_user.id, sender_id: top_sender.id)

      {:reply, reply} =
        Actions.MonthlyStats.run(%{text: "what are the monthly stats"})

      # sender leaderboard
      assert String.contains?(
               reply,
               """
               1. #{top_sender.username} - 2
               2. #{avg_user.username} - 1\
               """
             )

      # receiver leaderboard
      assert String.contains?(
               reply,
               """
               1. #{top_receiver.username} - 2
               2. #{avg_user.username} - 1\
               """
             )
    end

    test "ignores old high fives" do
      sender = insert(:user)
      old_receiver = insert(:user)
      new_receiver = insert(:user)
      two_months_ago = Timex.now() |> Timex.shift(months: -2)

      _new_high_five =
        insert(:high_five, receiver_id: new_receiver.id, sender_id: sender.id)

      _old_high_five =
        insert(:high_five,
          receiver_id: old_receiver.id,
          sender_id: sender.id,
          inserted_at: two_months_ago
        )

      {:reply, reply} =
        Actions.MonthlyStats.run(%{text: "give me the monthly stats"})

      assert String.contains?(reply, "1. #{new_receiver.username} - 1")
      refute String.contains?(reply, old_receiver.username)
    end

    test "ignores users who haven't given or received high fives" do
      sender = insert(:user)
      receiver = insert(:user)
      other_user = insert(:user)
      insert(:high_five, receiver_id: receiver.id, sender_id: sender.id)

      {:reply, reply} =
        Actions.MonthlyStats.run(%{text: "give me the monthly stats"})

      refute String.contains?(reply, other_user.username)
    end
  end
end
