defmodule Corker.Slack.Actions.WeeklyListTest do
  use Corker.DataCase, async: true

  alias Corker.Slack.Actions

  describe "run/1" do
    test "ignores if the command is invalid" do
      assert nil ==
               Actions.WeeklyList.run(%{text: "just a command", user: "123"})
    end

    test "correctly formats the message with the weekly report" do
      sender = insert(:user)
      receiver = insert(:user)

      high_fives =
        insert_list(2, :high_five,
          receiver_id: receiver.id,
          sender_id: sender.id
        )

      {:reply, reply} =
        Actions.WeeklyList.run(%{
          text: "list my high fives",
          user: receiver.slack_id
        })

      for high_five <- high_fives do
        assert String.contains?(
                 reply,
                 """
                 From: <@#{sender.slack_id}>: #{high_five.reason}\
                 """
               )
      end
    end
  end
end
