defmodule Corker.Web.Pong do
  @middleware [Tesla.Middleware.JSON]

  def send_to(url) do
    @middleware
    |> Tesla.client()
    |> Tesla.get(url)
  end
end
