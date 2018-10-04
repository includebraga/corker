use Mix.Config

config :corker, :slack, oauth_token: {:system, "SLACK_BOT_OAUTH_TOKEN"}

config :corker, Corker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "corker_dev",
  hostname: "localhost",
  pool_size: 10
