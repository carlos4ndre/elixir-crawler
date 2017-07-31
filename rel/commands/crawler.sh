#!/bin/sh

echo "Running elixir crawler"
bin/elixir_crawler command Elixir.CLI.Runner start "$@"
