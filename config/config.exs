use Mix.Config

import_config "../apps/*/config/config.exs"

config :mix_docker,
    image: "elixir-crawler",
    dockerfile_build: "docker/Dockerfile.build",
    dockerfile_release: "docker/Dockerfile.release"
