defmodule Corker.Application do
  @moduledoc false
  @env Mix.env()

  use Application

  import Corker.Config, only: [config!: 2]

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Corker.Supervisor]

    Supervisor.start_link(children(@env), opts)
  end

  defp children(:test), do: base_children()

  defp children(_) do
    token = config!(:slack, :oauth_token)

    [
      %{
        id: Slack.Bot,
        start: {Slack.Bot, :start_link, [Corker.Slack, %{}, token]}
      }
    ] ++ base_children()
  end

  defp base_children, do: [Corker.Repo, Corker.Web]
end
