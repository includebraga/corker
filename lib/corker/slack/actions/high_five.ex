defmodule Corker.Slack.Actions.HighFive do
  @cmd_regex ~r/((give|send) ((a high\s*five)|props)) to <@([^>]+)> (.*)/

  alias Corker.Slack.Messages

  alias Corker.{
    Accounts,
    Feedback
  }

  def run(%{text: text, user: user}) do
    case Regex.run(@cmd_regex, text) do
      nil ->
        nil

      matches ->
        do_run(
          receiver: Enum.at(matches, -2),
          reason: Enum.at(matches, -1),
          sender: user
        )
    end
  end

  defp do_run(receiver: receiver, reason: reason, sender: sender) do
    sender_id = Accounts.find_by(slack_id: sender).id
    receiver_id = Accounts.find_by(slack_id: receiver).id

    Feedback.create_high_five(%{
      sender_id: sender_id,
      receiver_id: receiver_id,
      reason: reason
    })

    beginning_of_week = Timex.now() |> Timex.beginning_of_week(:mon)

    high_five_count =
      receiver_id
      |> Feedback.high_fives_since(beginning_of_week)
      |> length

    reply =
      Messages.t("high_five.created",
        receiver_id: receiver,
        high_five_count: high_five_count
      )

    {:reply, reply}
  end
end
