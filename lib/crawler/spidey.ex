defmodule Crawler.Spidey do
  @max_depth 2
  @task_timeout 60000

  def generate_sitemap(url) do
    Crawler.SiteMap.start_link
    populate_sitemap(url, url)
    Crawler.SiteMap.to_json
  end

  defp populate_sitemap(base, url, max_depth \\ @max_depth)

  defp populate_sitemap(_base, url, 0) do
    IO.puts "[!] Crawler reached maximum depth for url #{url}"
  end

  defp populate_sitemap(base, url, max_depth) do
    try do
      IO.puts "[+] Process url #{url}"
      page = Crawler.Page.process_page(url)
      urls_to_follow = page.sites
                        |> Enum.filter(&(!site_already_processed?(&1)))
                        |> Enum.map(&convert_to_absolute_url(base, &1))
                        |> Enum.filter(&(is_valid_site?(base, &1)))

      # save page before start processing any url
      add_page_to_sitemap(page)

      urls_to_follow
      |> Enum.map(&Task.async(fn -> populate_sitemap(base, &1, max_depth-1) end))
      |> Enum.map(&Task.await(&1, @task_timeout))
    rescue
      e in RuntimeError -> e
    end
  end

  defp add_page_to_sitemap(page) do
    unless Crawler.SiteMap.has_page?(page.url) do
      Crawler.SiteMap.add_page(page)
    end
  end

  defp convert_to_absolute_url(base, url) do
    cond do
      String.match?(url, ~r/^(http|https)/) -> url
      String.match?(url, ~r/^\//)           -> "#{base}#{url}"
      true                                  -> "#{base}/#{url}"
    end
  end

  defp is_valid_site?(base, url) do
    String.contains?(url, base)
  end

  defp site_already_processed?(url) do
    Crawler.SiteMap.has_page?(url)
  end
end
