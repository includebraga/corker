defmodule Corker.Slack.HighFives do
  @self_fives_allowed Application.get_env(:corker, __MODULE__)[:self_fives]

  alias Corker.{
    Accounts,
    Feedback
  }

  def create(receiver_slack_id, sender_slack_id, reason) do
    sender = Accounts.find_by(slack_id: sender_slack_id)
    receiver = Accounts.find_by(slack_id: receiver_slack_id)

    cond do
      is_nil(receiver) ->
        {:error, :no_receiver}

      receiver_slack_id == sender_slack_id and not @self_fives_allowed ->
        {:error, :self_five}

      true ->
        Feedback.create_high_five(%{
          sender_id: sender.id,
          receiver_id: receiver.id,
          reason: reason
        })
    end
  end
end
