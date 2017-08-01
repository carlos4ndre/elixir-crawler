#!/bin/sh

echo "Starting beam node"
bin/elixir_crawler start
sleep 5

echo "Running elixir crawler"
shift
bin/elixir_crawler rpc Elixir.CLI.Runner main $@
echo "Done!"
