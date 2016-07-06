defmodule Crawler.Spidey do
  require Logger
  @task_timeout 60000
  @domain_regex ~r/^http[s]{0,1}:\/\/(.*?)(?:[\/?&#]|$)/i

  def generate_sitemap({url, max_depth}) do
    Logger.info "Generate sitemap for #{url} using a max_depth of #{max_depth}"
    Crawler.SiteMap.start_link
    populate_sitemap(url, url, max_depth)
    Crawler.SiteMap.to_json
  end

  defp populate_sitemap(base, url, max_depth)

  defp populate_sitemap(_base, url, 0) do
    Logger.warn "Crawler reached maximum depth for url #{url}"
  end

  defp populate_sitemap(base, url, max_depth) do
    try do
      if url_already_processed?(url) do
        Logger.info "Already processed url #{url}"
      else
        Logger.info "Process url #{url}"
        page = Crawler.Page.process_page(url)
        urls_to_follow = page.sites
                          |> Enum.filter(&(!url_already_processed?(&1)))
                          |> Enum.map(&convert_to_absolute_url(base, &1))
                          |> Enum.filter(&(from_same_domain?(base, &1)))

        # save page before start processing any url
        add_page_to_sitemap(page)

        urls_to_follow
        |> Enum.map(&Task.async(fn -> populate_sitemap(base, &1, max_depth-1) end))
        |> Enum.map(&Task.await(&1, @task_timeout))
      end
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

  defp from_same_domain?(base, url) do
    source_domain = extract_domain_from_url(base)
    target_domain = extract_domain_from_url(url)
    String.contains?(target_domain, source_domain)
  end

  defp extract_domain_from_url(url) do
    Regex.run(@domain_regex, url) |> Enum.at(1)
  end

  defp url_already_processed?(url) do
    Crawler.SiteMap.has_page?(url)
  end
end
