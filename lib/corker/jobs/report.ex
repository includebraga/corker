defmodule Corker.Jobs.Report do
  alias Corker.Reports
  alias Corker.Slack.Messages

  @channel Application.get_env(:corker, __MODULE__)[:channel]

  def send do
    report = generate_report()
    send slack_pid(), {:report, report, @channel}
  end

  defp generate_report do
    {sender_stats, receiver_stats} =
      Reports.Monthly.generate(backdate: true) |> to_paragraph()

    prefix = Messages.t("reports.monthly.prefix")
    receiver_str = Messages.t("reports.monthly.receiver", stats: receiver_stats)
    sender_str = Messages.t("reports.monthly.sender", stats: sender_stats)

    prefix <> "\n\n" <> receiver_str <> "\n\n" <> sender_str
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

  defp slack_pid do
    Corker.Supervisor
    |> Supervisor.which_children()
    |> Enum.find(fn {mod, _, _, _} -> mod == Slack.Bot end)
    |> elem(1)
  end
end
