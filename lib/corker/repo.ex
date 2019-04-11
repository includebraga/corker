defmodule Corker.Repo do
  use Ecto.Repo,
    otp_app: :corker,
    adapter: Ecto.Adapters.Postgres
end
