use Mix.Config

config :corker, Corker.Repo,
  username: "postgres",
  password: "postgres",
  database: "corker_dev",
  hostname: "localhost",
  pool_size: 10
