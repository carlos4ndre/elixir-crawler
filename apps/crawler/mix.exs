defmodule Crawler.Mixfile do
  use Mix.Project

  def project do
    [
      app: :crawler,
      version: "0.1.0",
      elixir: "~> 1.5.0",
      start_permanent: Mix.env == :prod,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison, :poolboy],
      mod: { Crawler.Application, [] },
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.12.0"},
      {:poison, "~> 3.1.0"},
      {:poolboy, "~> 1.5.1"},
      {:floki, "~> 0.17.2"},
      {:sitemap, in_umbrella: true},
    ]
  end
end
