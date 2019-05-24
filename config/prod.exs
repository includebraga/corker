use Mix.Config

config :corker, Corker.Web.Endpoint, port: {:system, "PORT"}

config :corker, Corker.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
