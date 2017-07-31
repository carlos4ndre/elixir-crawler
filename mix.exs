defmodule CrawlerUmbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps(),
    ]
  end

  defp deps do
    [
      {:mix_docker, "~> 0.5.0"},
    ]
  end
end
