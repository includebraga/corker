use Mix.Config

config :corker,
  ecto_repos: [Corker.Repo]

config :corker, Corker.Web.Endpoint, port: 4000

config :corker, :slack, oauth_token: {:system, "SLACK_BOT_OAUTH_TOKEN"}

config :corker, Corker.Jobs.Report, channel: "#bottest"

config :corker, Corker.Slack.HighFives, self_fives: false

import_config "#{Mix.env()}.exs"
