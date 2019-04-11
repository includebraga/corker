defmodule Corker.FeedbackTest do
  use Corker.DataCase, async: true

  alias Corker.Feedback

  describe "high_fives_since/2" do
    test "returns only high fives for the given user" do
      sender = insert(:user)
      receiver = insert(:user)
      another_receiver = insert(:user)

      %{id: id} =
        insert(:high_five,
          sender_id: sender.id,
          receiver_id: receiver.id
        )

      insert(:high_five,
        sender_id: sender.id,
        receiver_id: another_receiver.id
      )

      yesterday = Timex.now() |> Timex.shift(days: -1)

      [%{id: ^id}] = Feedback.high_fives_since(receiver.id, yesterday)
    end

    test "returns only high fives after the given date" do
      one_week_ago = Timex.now() |> Timex.shift(weeks: -1)
      sender = insert(:user)
      receiver = insert(:user)

      %{id: id} =
        insert(:high_five,
          sender_id: sender.id,
          receiver_id: receiver.id
        )

      insert(:high_five,
        sender_id: sender.id,
        receiver_id: receiver.id,
        inserted_at: one_week_ago
      )

      yesterday = Timex.now() |> Timex.shift(days: -1)

      [%{id: ^id}] = Feedback.high_fives_since(receiver.id, yesterday)
    end
  end
end
