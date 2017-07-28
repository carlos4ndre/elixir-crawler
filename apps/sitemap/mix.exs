defmodule Sitemap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sitemap,
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
      extra_applications: [:logger],
      mod: {SiteMap.Application, []},
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1.0"},
    ]
  end
end
