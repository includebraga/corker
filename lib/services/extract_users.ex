defmodule Corker.Services.ExtractUsers do
  use Task

  def start(users) do
    Task.start(__MODULE__, :perform, [users])
  end

  def perform(_users) do
    :ok
  end
end
