defmodule Corker.Slack do
  use Slack

  require IEx

  def handle_connect(slack, state) do
    Corker.Services.ExtractUsers.start(slack.users)

    {:ok, state}
  end

  def handle_message(_message, _slack, state) do
    {:ok, state}
  end
end
