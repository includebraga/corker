defmodule Corker.Reports.Monthly do
  alias Corker.{
    Accounts,
    Feedback
  }

  def generate(opts \\ []) do
    {start_date, end_date} = backdated_intervals(opts)

    Accounts.all_users()
    |> high_five_count_between(start_date, end_date)
    |> scrub_high_fives()
  end

  defp backdated_intervals(opts) do
    if Keyword.get(opts, :backdate, false) do
      {
        Timex.now() |> Timex.shift(months: -1) |> Timex.beginning_of_month(),
        Timex.now() |> Timex.shift(months: -1) |> Timex.end_of_month()
      }
    else
      {
        Timex.now() |> Timex.beginning_of_month(),
        Timex.now()
      }
    end
  end

  defp high_five_count_between(users, start_date, end_date) do
    Enum.reduce(users, {%{}, %{}}, fn u, {senders, receivers} ->
      high_fives = Feedback.high_fives_between(u.id, start_date, end_date)
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
end
