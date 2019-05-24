use Mix.Config

config :corker,
  ecto_repos: [Corker.Repo]

config :corker, Corker.Web.Endpoint, port: 4000

import_config "#{Mix.env()}.exs"
