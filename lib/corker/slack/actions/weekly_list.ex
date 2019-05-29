defmodule Corker.Slack.Actions.WeeklyList do
  @cmd_regex ~r/(list my high fives)/

  alias Corker.Reports
  alias Corker.Slack.Messages

  def run(%{text: text, user: user}) do
    if Regex.match?(@cmd_regex, text) do
      do_run(user)
    end
  end

  defp do_run(slack_id) do
    high_fives =
      slack_id
      |> Reports.Weekly.for()
      |> to_paragraph()

    reply = Messages.t("high_five.list", high_fives: high_fives)

    {:reply, reply}
  end

  defp to_paragraph(report) do
    report
    |> Stream.map(fn {sender_slack_id, reason} ->
      "From: <@#{sender_slack_id}>: #{reason}"
    end)
    |> Enum.join("\n")
  end
end
