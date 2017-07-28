defmodule CLI.Runner do
  require Logger

  @default_max_depth 2

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, [url, max_depth], _} -> {url, String.to_integer(max_depth)}
      {_, [url],            _} -> {url, @default_max_depth}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts("usage:  crawler <url> [ max_depth | #{@default_max_depth} ]")
    System.halt(0)
  end

  def process({url, max_depth}) do
    Logger.info("Generate sitemap for #{url} using a max_depth of #{max_depth}")
    Crawler.scrape_website({url, max_depth})
    Crawler.print_results()
  end
end
