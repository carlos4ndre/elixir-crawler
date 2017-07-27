defmodule Crawler do
  alias Crawler.Spidey

  defdelegate scrape_website(options), to: Spidey
  defdelegate print_results(), to: Spidey
end
