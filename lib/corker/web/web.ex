defmodule Corker.Web do
  use Supervisor

  import Corker.Config, only: [config!: 2]

  alias Corker.Web

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Web.Endpoint,
        options: [port: port()]
      )
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end

  defp port do
    case config!(Web.Endpoint, :port) do
      port when is_integer(port) ->
        port

      port when is_binary(port) ->
        {int, ""} = Integer.parse(port)
        int
    end
  end
end
