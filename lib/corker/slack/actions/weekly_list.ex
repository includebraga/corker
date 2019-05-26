defmodule Corker.Slack.Actions.WeeklyList do
  @cmd_regex ~r/(list my high fives)/

  alias Corker.Slack.Messages

  alias Corker.{
    Accounts,
    Feedback
  }

  def run(%{text: text, user: user}) do
    if Regex.match?(@cmd_regex, text) do
      do_run(user)
    end
  end

  defp do_run(slack_id) do
    user = Accounts.find_by(slack_id: slack_id)

    beginning_of_week = Timex.now() |> Timex.beginning_of_week(:mon)

    high_fives =
      user.id
      |> Feedback.high_fives_since(beginning_of_week)
      |> to_paragraph()

    reply = Messages.t("high_five.list", high_fives: high_fives)

    {:reply, reply}
  end

  defp to_paragraph(high_fives) do
    high_fives
    |> Enum.map(fn high_five ->
      sender = Accounts.find_by(id: high_five.sender_id)

      "* From: <@#{sender.slack_id}>: #{high_five.reason}"
    end)
    |> Enum.join("\n")
  end
end
