defmodule Corker.Web.Endpoint do
  use Plug.Router

  require Logger

  alias Corker.Web

  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug :dispatch

  get "/ping" do
    conn
    |> attempt_pong()
    |> put_resp_content_type("application/json")
    |> send_resp(200, "")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp attempt_pong(conn) do
    conn
    |> get_req_header("x-health-check-pong")
    |> case do
      [] ->
        Logger.info("Received ping but no pong header was set")

      [url] ->
        Logger.info("Received ping, sending pong to #{url}")
        Web.Pong.send_to(url)
    end

    conn
  end
end
