defmodule Sitemap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sitemap,
      version: "0.1.0",
      elixir: "~> 1.5.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: { SiteMap.Application, [] },
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1.0"},
    ]
  end
end
