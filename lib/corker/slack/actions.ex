defmodule Corker.Slack.Actions do
  alias Corker.Slack.Messages

  @actions [
    __MODULE__.HighFive
  ]

  # we don't care about control-style messages,
  # we only care about actual communications so ignore
  # all messages with a subtype
  def parse(%{subtype: _}, _), do: :noreply

  # this is how slack distinguishes channel messages from DMs:
  # by setting the channel id to start with a D
  def parse(%{channel: "D" <> _}, _) do
    {:reply, Messages.t("error.dm_received")}
  end

  def parse(%{text: text} = message, %{id: id}) do
    case Regex.run(~r/^<@#{id}>\s+(.*)/, text) do
      nil -> :noreply
      [_, _] -> run_command(message)
    end
  end

  defp run_command(message) do
    Enum.reduce_while(
      @actions,
      {:reply, Messages.t("error.unknown_command")},
      fn action, acc ->
        case action.run(message) do
          nil -> {:cont, acc}
          response -> {:halt, response}
        end
      end
    )
  end
end
