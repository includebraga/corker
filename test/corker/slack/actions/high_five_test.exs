defmodule Corker.Slack.Actions.HighFiveTest do
  use Corker.DataCase, async: true

  alias Corker.Feedback
  alias Corker.Repo

  alias Corker.Slack.{
    Actions.HighFive,
    Messages
  }

  describe "run/1" do
    test "returns nil if the command is invalid" do
      assert nil == HighFive.run(%{text: "just a command", user: "123"})
    end

    test "creates a high five" do
      sender = insert(:user)
      receiver = insert(:user)
      text = "give a high five to <@#{receiver.slack_id}> for being awesome"

      HighFive.run(%{text: text, user: sender.slack_id})

      high_five = Repo.one(Feedback.HighFive)

      assert high_five.sender_id == sender.id
      assert high_five.receiver_id == receiver.id
      assert high_five.reason == "for being awesome"
    end

    test "returns the receiver high five count" do
      sender = insert(:user)
      receiver = insert(:user)
      two_weeks_ago = Timex.now() |> Timex.shift(weeks: -2)
      insert(:high_five, receiver_id: receiver.id)
      insert(:high_five, receiver_id: receiver.id, inserted_at: two_weeks_ago)
      text = "give a high five to <@#{receiver.slack_id}> for being awesome"

      response = HighFive.run(%{text: text, user: sender.slack_id})

      reply =
        Messages.t("high_five.created",
          receiver_id: receiver.slack_id,
          high_five_count: 2
        )

      assert {:reply, reply} == response
    end
  end
end
