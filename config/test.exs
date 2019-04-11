use Mix.Config

config :logger, level: :warn

config :corker, Corker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "postgres",
  database: "corker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
