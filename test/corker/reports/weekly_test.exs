defmodule Corker.Reports.WeeklyTest do
  use Corker.DataCase, async: true

  alias Corker.Reports.Weekly

  describe "for/1" do
    test "returns a list of the sender and reason for the high five" do
      receiver = insert(:user)
      sender = insert(:user)

      high_fives =
        insert_list(2, :high_five,
          receiver_id: receiver.id,
          sender_id: sender.id
        )

      report = Weekly.for(receiver.slack_id)

      assert report ==
               for(
                 high_five <- high_fives,
                 do: {sender.slack_id, high_five.reason}
               )
    end

    test "ignores old high fives" do
      sender = insert(:user)
      receiver = insert(:user)
      two_weeks_ago = Timex.now() |> Timex.shift(weeks: -2)

      new_high_five =
        insert(:high_five, receiver_id: receiver.id, sender_id: sender.id)

      _old_high_five =
        insert(:high_five,
          receiver_id: receiver.id,
          sender_id: sender.id,
          inserted_at: two_weeks_ago
        )

      report = Weekly.for(receiver.slack_id)

      assert [{sender.slack_id, new_high_five.reason}] == report
    end

    test "ignores other user's high fives" do
      sender = insert(:user)
      receiver = insert(:user)
      another_receiver = insert(:user)

      receiver_high_five =
        insert(:high_five, receiver_id: receiver.id, sender_id: sender.id)

      _other_high_five =
        insert(:high_five,
          receiver_id: another_receiver.id,
          sender_id: sender.id
        )

      report = Weekly.for(receiver.slack_id)

      assert [{sender.slack_id, receiver_high_five.reason}] == report
    end
  end
end
