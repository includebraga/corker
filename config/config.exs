use Mix.Config

config :corker,
  ecto_repos: [Corker.Repo]

import_config "#{Mix.env()}.exs"
