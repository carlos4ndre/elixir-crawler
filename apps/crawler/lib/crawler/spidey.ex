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
    sitemap = SiteMap.get_sitemap()
    for {_, page} <- sitemap do
      print_page(page)
    end
  end

  defp print_page(page) do
    print_page_title(page.url)
    print_page_sites(page.sites)
    print_page_images(page.images)
  end

  defp print_page_title(url) do
    separator = url
                |> String.length()
                |> (&String.duplicate("-", &1)).()

    IO.puts(separator)
    IO.puts(url)
    IO.puts(separator)
  end

  defp print_page_sites(sites) do
    IO.puts("SITES:")
    Enum.each(sites, &IO.puts("> #{&1}"))
  end

  defp print_page_images(images) do
    IO.puts("IMAGES:")
    Enum.each(images, &IO.puts("> #{&1}"))
  end

  defp fetch_page(url) do
    fn -> :poolboy.transaction(
      :page_pool,
      &(GenServer.call(&1, {:fetch, url})),
      @timeout)
    end
  end

end
