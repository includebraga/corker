defmodule Corker.Slack.Actions.HighFive do
  @cmd_regex ~r/<@([^>]+)> <@([^>]+)> (.*)/

  alias Corker.Slack.{
    HighFives,
    Messages
  }

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
    case HighFives.create(receiver_slack_id, sender_slack_id, reason) do
      {:error, :no_receiver} ->
        msg =
          Messages.t("high_five.errors.receiver_not_found",
            slack_id: receiver_slack_id
          )

        {:reply, msg}

      {:error, :self_five} ->
        {:reply, Messages.t("high_five.errors.self_five")}

      {:ok, high_five} ->
        {:reply, high_five_data(high_five)}
    end
  end

  defp high_five_data(high_five) do
    receiver = Accounts.find_by(id: high_five.receiver_id)

    beginning_of_week = Timex.now() |> Timex.beginning_of_week(:mon)

    high_five_count =
      receiver.id
      |> Feedback.high_fives_since(beginning_of_week)
      |> length

    Messages.t("high_five.created",
      receiver_username: receiver.username,
      high_five_count: high_five_count
    )
  end
end
