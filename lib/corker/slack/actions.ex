defmodule Corker.Slack.Actions do
  alias Corker.Slack.Messages

  @shared_actions [
    __MODULE__.MonthlyStats
  ]

  @dm_actions [
    __MODULE__.WeeklyList
    | @shared_actions
  ]

  @public_channel_actions [
    __MODULE__.HighFive
    | @shared_actions
  ]

  # we don't care about control-style messages,
  # we only care about actual communications so ignore
  # all messages with a subtype
  def parse(%{subtype: _}, _), do: :noreply

  # this is how slack distinguishes channel messages from DMs:
  # by setting the channel id to start with a D
  def parse(%{channel: "D" <> _} = message, _) do
    error_msg = Messages.t("error.dm_received")
    run_actions(@dm_actions, message, error_msg)
  end

  def parse(%{text: text} = message, %{id: id}) do
    case Regex.run(~r/^<@#{id}>\s+(.*)/, text) do
      nil ->
        :noreply

      [_, _] ->
        error_msg = Messages.t("error.unknown_command")
        run_actions(@public_channel_actions, message, error_msg)
    end
  end

  defp run_actions(actions, message, default_response) do
    Enum.reduce_while(
      actions,
      {:reply, default_response},
      fn action, acc ->
        case action.run(message) do
          nil -> {:cont, acc}
          response -> {:halt, response}
        end
      end
    )
  end
end
