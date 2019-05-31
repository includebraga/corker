defmodule Corker.Slack do
  use Slack

  alias Corker.Slack.{
    Actions,
    Users
  }

  def handle_connect(%{users: users}, state) do
    Users.extract(users)

    {:ok, state}
  end

  def handle_event(%{type: "message"} = message, slack, state) do
    case Actions.parse(message, slack.me) do
      {:reply, text} ->
        send_message(text, message.channel, slack)

      :noreply ->
        nil
    end

    {:ok, state}
  end

  def handle_event(%{type: "team_join", user: user}, _slack, state) do
    Users.extract([user])

    {:ok, state}
  end

  def handle_event(_message, _slack, state) do
    {:ok, state}
  end

  def handle_info({:report, report, channel}, slack, state) do
    send_message(report, channel, slack)

    {:ok, state}
  end
end
