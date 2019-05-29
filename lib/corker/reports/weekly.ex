defmodule Corker.Reports.Weekly do
  alias Corker.{
    Accounts,
    Feedback
  }

  def for(slack_id) do
    user = Accounts.find_by(slack_id: slack_id)

    beginning_of_week = Timex.now() |> Timex.beginning_of_week(:mon)

    user.id
    |> Feedback.high_fives_since(beginning_of_week)
    |> compile_list()
  end

  defp compile_list(high_fives) do
    Enum.map(high_fives, fn high_five ->
      sender = Accounts.find_by(id: high_five.sender_id)

      {sender.slack_id, high_five.reason}
    end)
  end
end
