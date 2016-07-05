defmodule Crawler.Page do
  @user_agent [{"User-agent", "Elixir Crawler (Fear not!)"}]

  def process_page(url) do
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
    sites = extract_site_urls(content)
    images = extract_image_urls(content)

    %Page{url: url, sites: sites, images: images}
  end

  defp extract_site_urls(content) do
    content
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.uniq
  end

  defp extract_image_urls(content) do
    content
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> Enum.uniq
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
