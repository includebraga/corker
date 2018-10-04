defmodule Corker.Application do
  @moduledoc false
  use Application

  import Corker.Config, only: [config!: 2]

  def start(_type, _args) do
    token = config!(:slack, :oauth_token)
    opts = [strategy: :one_for_one, name: Corker.Supervisor]

    children = [
      %{
        id: Slack.Bot,
        start: {Slack.Bot, :start_link, [Corker.Slack, [], token]}
      }
    ]

    Supervisor.start_link(children, opts)
  end
end
