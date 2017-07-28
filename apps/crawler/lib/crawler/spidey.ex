defmodule Crawler.Spidey do
  require Logger
  alias Crawler.Validation

  @timeout 60_000

  def scrape_website({url, 0}) do
    Logger.warn("Crawler has reached maximum depth for url #{url}")
  end

  def scrape_website({url, max_depth}) do
    task = Task.async(fetch_page(url))
    page = Task.await(task, @timeout)
    SiteMap.add_page(page)

    # follow valid websites
    page.sites
    |> Enum.filter(&Validation.url_valid?/1)
    |> Enum.map(&(Task.async(fn -> scrape_website({&1, max_depth - 1}) end)))
    |> Enum.map(&Task.await/1)
  end

  def print_results() do
    SiteMap.to_json()
    |> IO.puts
  end

  defp fetch_page(url) do
    fn -> :poolboy.transaction(
      :page_pool,
      &(GenServer.call(&1, {:fetch, url})),
      @timeout)
    end
  end

end
