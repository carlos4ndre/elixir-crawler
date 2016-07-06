defmodule Crawler.CLI do
  @default_max_depth 2

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ url, max_depth ], _ } -> { url, String.to_integer(max_depth) }
      { _, [ url ],            _ } -> { url, @default_max_depth }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage:  crawler <url> [ max_depth | #{@default_max_depth} ]
    """
    System.halt(0)
  end

  def process({url, max_depth}) do
    IO.puts Crawler.Spidey.generate_sitemap({url, max_depth})
  end
end
