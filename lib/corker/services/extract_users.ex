defmodule Corker.Services.ExtractUsers do
  use Task

  alias Corker.Accounts

  def start(users) do
    Task.start(__MODULE__, :perform, [users])
  end

  def perform(users) do
    require IEx

    for {id, user} <- users do
      IEx.pry()
      Accounts.create_user(%{username: user[:name], slack_id: id})
    end

    :ok
  end
end
