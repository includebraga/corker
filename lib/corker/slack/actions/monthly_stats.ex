defmodule Corker.Slack.Actions.MonthlyStats do
  @cmd_regex ~r/((give me|what are) the monthly stats)/

  alias Corker.Slack.Messages

  alias Corker.{
    Accounts,
    Feedback
  }

  def run(%{text: text}) do
    if Regex.match?(@cmd_regex, text),
      do: do_run()
  end

  defp do_run do
    users = Accounts.all_users()

    beginning_of_month = Timex.now() |> Timex.beginning_of_month()

    {sender_stats, receiver_stats} =
      users
      |> high_five_count_since(beginning_of_month)
      |> scrub_high_fives()
      |> to_paragraph()

    sender_str =
      Messages.t("high_five.monthly_stats.sender", stats: sender_stats)

    receiver_str =
      Messages.t("high_five.monthly_stats.receiver", stats: receiver_stats)

    reply = sender_str <> "\n\n" <> receiver_str

    {:reply, reply}
  end

  defp high_five_count_since(users, date) do
    Enum.reduce(users, {%{}, %{}}, fn u, {senders, receivers} ->
      high_fives = Feedback.high_fives_since(u.id, date)
      new_receivers = Map.put(receivers, u.username, length(high_fives))
      new_senders = update_senders(senders, high_fives)

      {new_senders, new_receivers}
    end)
  end

  defp update_senders(senders, high_fives) do
    Enum.reduce(high_fives, senders, fn hf, acc ->
      sender = Accounts.find_by(id: hf.sender_id)
      Map.update(acc, sender.username, 1, &(&1 + 1))
    end)
  end

  defp scrub_high_fives({senders, receivers}),
    do: {scrub(senders), scrub(receivers)}

  defp scrub(users) do
    users
    |> Enum.sort_by(fn {_u, count} -> count end, &>=/2)
    |> Enum.take_while(fn {_u, count} -> count > 0 end)
  end

  defp to_paragraph({sender_stats, receiver_stats}) do
    {stats_to_str(receiver_stats), stats_to_str(sender_stats)}
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
