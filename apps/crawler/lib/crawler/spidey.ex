defmodule Crawler.Spidey do
  require Logger

  @timeout 60000

  def scrape_website({url, 0}) do
    Logger.warn("Crawler reached maximum depth for url #{url}")
  end

  def scrape_website({url, max_depth}) do
    task = Task.async(fetch_page_async(url))
    page = Task.await(task, @timeout)
    SiteMap.add_page(page)

    # follow links
    page.sites
    |> Enum.each(&scrape_website({&1, max_depth-1}))
  end

  def print_results() do
    SiteMap.to_json()
    |> IO.puts
  end

  defp fetch_page_async(url) do
    fn -> :poolboy.transaction(
      :page_pool,
      &(GenServer.call(&1, {:fetch, url})),
      @timeout)
    end
  end

end
