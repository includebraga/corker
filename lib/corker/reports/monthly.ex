defmodule Corker.Reports.Monthly do
  alias Corker.{
    Accounts,
    Feedback
  }

  def generate do
    users = Accounts.all_users()

    beginning_of_month = Timex.now() |> Timex.beginning_of_month()

    users
    |> high_five_count_since(beginning_of_month)
    |> scrub_high_fives()
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
end
