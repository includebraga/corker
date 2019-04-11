defmodule Corker.Slack.Users do
  use Task

  alias Corker.Accounts

  @slackbot_id "USLACKBOT"

  def extract(users) do
    for {id, user} <- users,
        not user[:is_bot],
        not user[:is_app_user],
        not user[:deleted],
        user[:id] != @slackbot_id do
      unless Accounts.exists_user?(user[:name]) do
        Accounts.create_user(%{username: user[:name], slack_id: id})
      end
    end

    :ok
  end
end
