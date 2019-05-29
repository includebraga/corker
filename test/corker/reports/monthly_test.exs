defmodule Corker.Reports.MonthlyTest do
  use Corker.DataCase, async: true

  alias Corker.Reports.Monthly

  describe "generate/0" do
    test "returns the leaderboards for this month" do
      top_sender = insert(:user)
      top_receiver = insert(:user)
      avg_user = insert(:user)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: top_sender.id)
      insert(:high_five, receiver_id: top_receiver.id, sender_id: avg_user.id)
      insert(:high_five, receiver_id: avg_user.id, sender_id: top_sender.id)

      {sender_stats, receiver_stats} = Monthly.generate()

      # sender leaderboard
      assert [
               {top_sender.username, 2},
               {avg_user.username, 1}
             ] == sender_stats

      # receiver leaderboard
      assert [
               {top_receiver.username, 2},
               {avg_user.username, 1}
             ] == receiver_stats
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

      {_sender_stats, receiver_stats} = Monthly.generate()

      assert [{new_receiver.username, 1}] == receiver_stats
    end

    test "ignores users who haven't given or received high fives" do
      sender = insert(:user)
      receiver = insert(:user)
      _other_user = insert(:user)
      insert(:high_five, receiver_id: receiver.id, sender_id: sender.id)

      {sender_stats, receiver_stats} = Monthly.generate()

      assert [{receiver.username, 1}] == receiver_stats
      assert [{sender.username, 1}] == sender_stats
    end
  end
end
