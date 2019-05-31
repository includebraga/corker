defmodule Corker.Slack.Actions.HighFive do
  @cmd_regex ~r/((give|send) ((a high\s*five)|props)) to <@([^>]+)> (.*)/

  @self_fives_allowed Application.get_env(:corker, :high_fives)[:self_fives]

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

  defp do_run(
         receiver: receiver_slack_id,
         reason: reason,
         sender: sender_slack_id
       ) do
    sender = Accounts.find_by(slack_id: sender_slack_id)
    receiver = Accounts.find_by(slack_id: receiver_slack_id)

    cond do
      is_nil(receiver) ->
        msg =
          Messages.t("high_five.errors.receiver_not_found",
            slack_id: receiver_slack_id
          )

        {:reply, msg}

      receiver_slack_id == sender_slack_id and not @self_fives_allowed ->
        {:reply, Messages.t("high_five.errors.self_five")}

      true ->
        create_high_five(sender, receiver, reason)
    end
  end

  defp create_high_five(sender, receiver, reason) do
    Feedback.create_high_five(%{
      sender_id: sender.id,
      receiver_id: receiver.id,
      reason: reason
    })

    beginning_of_week = Timex.now() |> Timex.beginning_of_week(:mon)

    high_five_count =
      receiver.id
      |> Feedback.high_fives_since(beginning_of_week)
      |> length

    reply =
      Messages.t("high_five.created",
        receiver_username: receiver.username,
        high_five_count: high_five_count
      )

    {:reply, reply}
  end
end
