defmodule Cli.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cli,
      version: "0.1.0",
      elixir: "~> 1.5.0",
      escript: [main_module: CLI.Runner],
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  defp deps do
    [
      {:crawler, path: "../crawler"},
    ]
  end
end
