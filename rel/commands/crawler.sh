#!/bin/sh

echo "Starting beam node"
bin/elixir_crawler start
sleep 5

echo "Running elixir crawler"
shift
shell_args="'Elixir.List':to_string(\"$@\")"
split_char="'Elixir.List':to_string(\" \")"
argv="'Elixir.String':split($shell_args, $split_char)"
bin/elixir_crawler eval "'Elixir.CLI.Runner':main($argv)"
echo "Done!"
