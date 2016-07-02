defmodule Crawler.Website do
  @user_agent [{"User-agent", "Elixir Crawler (Fear not!)"}]
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
      page = process_page(url)
      links_to_follow = page.sites
                        |> Enum.filter(&(!site_already_processed?(&1)))
                        |> Enum.map(&convert_link_to_absolute_url(base, &1))
                        |> Enum.filter(&(is_valid_site?(base, &1)))

      # save page before start processing any link
      add_page_to_sitemap(page)

      links_to_follow
      |> Enum.map(&Task.async(fn -> populate_sitemap(base, &1, max_depth-1) end))
      |> Enum.map(&Task.await(&1, @task_timeout))
    rescue
      e in RuntimeError -> e
    end
  end

  defp process_page(url) do
    html = case get_html_page(url) do
      {:ok, body} -> body
      {:redirect, _} -> raise "Not Implemented yet!"
      {:skip, _} -> raise "Ignore error and discard page"
      {:error, _} -> raise "Nasty error"
    end

    parse_html_page(url, html)
  end

  defp get_html_page(url) do
    url
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp parse_html_page(url, content) do
    sites = extract_site_links(content)
    images = extract_image_links(content)

    %Page{url: url, sites: sites, images: images}
  end

  defp extract_site_links(content) do
    content
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.map(fn(url) -> url end)
  end

  defp extract_image_links(content) do
    content
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Enum.map(fn(url) -> url end)
  end

  defp add_page_to_sitemap(page) do
    unless Crawler.SiteMap.has_page?(page.url) do
      Crawler.SiteMap.add_page(page)
    end
  end

  defp convert_link_to_absolute_url(base, link) do
    cond do
      String.match?(link, ~r/^(http|https)/) -> link
      String.match?(link, ~r/^\//)           -> "#{base}#{link}"
      true                                   -> "#{base}/#{link}"
    end
  end

  defp is_valid_site?(base, url) do
    String.contains?(url, base)
  end

  defp site_already_processed?(url) do
    Crawler.SiteMap.has_page?(url)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    { :ok, body }
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 301, body: body}}) do
    { :redirect, body }
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    IO.inspect "#{status_code} - #{body}"
    { :skip, body }
  end

  defp handle_response({_, %HTTPoison.Error{reason: reason}}) do
    IO.inspect reason
    { :error, reason }
  end
end
