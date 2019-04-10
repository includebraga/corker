defmodule Corker.Services.ExtractUsers do
  use Task

  alias Corker.Accounts

  @slackbot_id "USLACKBOT"

  def start(users) do
    Task.start(__MODULE__, :perform, [users])
  end

  def perform(users) do
    for {id, user} <- users,
        not user[:is_bot],
        not user[:is_app_user],
        not user[:deleted],
        user[:id] != @slackbot_id do
      Accounts.create_user(%{username: user[:name], slack_id: id})
    end

    :ok
  end
end
