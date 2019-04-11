defmodule Corker.MixProject do
  use Mix.Project

  @env Mix.env()

  def project do
    [
      app: :corker,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Corker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:slack, "~> 0.14.0"},
      {:timex, "~> 3.1"},
      {:yaml_elixir, "~> 2.2"}
    ] ++ deps(@env)
  end

  defp deps(env) when env in [:dev, :test] do
    [
      {:credo, "~> 0.10.0", runtime: false},
      {:ex_machina, "~> 2.3"},
      {:faker, "~> 0.11"},
      {:mock, "~> 0.3.0"}
    ]
  end

  defp deps(_), do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
