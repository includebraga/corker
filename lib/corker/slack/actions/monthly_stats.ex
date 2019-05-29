defmodule Corker.Slack.Actions.MonthlyStats do
  @cmd_regex ~r/((give me|what are) the monthly stats)/

  alias Corker.Reports
  alias Corker.Slack.Messages

  def run(%{text: text}) do
    if Regex.match?(@cmd_regex, text),
      do: do_run()
  end

  defp do_run do
    {sender_stats, receiver_stats} =
      Reports.Monthly.generate()
      |> to_paragraph()

    sender_str =
      Messages.t("high_five.monthly_stats.sender", stats: sender_stats)

    receiver_str =
      Messages.t("high_five.monthly_stats.receiver", stats: receiver_stats)

    reply = sender_str <> "\n\n" <> receiver_str

    {:reply, reply}
  end

  defp to_paragraph({sender_stats, receiver_stats}) do
    {stats_to_str(sender_stats), stats_to_str(receiver_stats)}
  end

  defp stats_to_str(stats) do
    stats
    |> Enum.with_index(1)
    |> Enum.map(fn {{username, count}, position} ->
      "#{position}. #{username} - #{count}"
    end)
    |> Enum.join("\n")
  end
end
