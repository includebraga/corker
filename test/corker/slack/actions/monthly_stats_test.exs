defmodule Corker.Slack.Actions.MonthlyStatsTest do
  use Corker.DataCase, async: true

  alias Corker.Slack.Actions.MonthlyStats

  describe "run/1" do
    test "ignores if the command is invalid" do
      assert nil == MonthlyStats.run(%{text: "just a command", user: "123"})
    end

    test "correctly formats the leaderboards" do
      top_sender = insert(:user)
      top_receiver = insert(:user)
      avg_user = insert(:user)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: top_sender.id)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: avg_user.id)
      insert(:high_five, receiver_id: avg_user.id, sender_id: top_sender.id)

      {:reply, reply} = MonthlyStats.run(%{text: "what are the monthly stats"})

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
  end
end
