defmodule Crawler.SiteMap do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def has_page?(url) do
    Agent.get __MODULE__, fn sitemap ->
      Dict.has_key?(sitemap, url)
    end
  end

  def add_page(page) do
    Agent.get_and_update __MODULE__, fn sitemap ->
      new_sitemap = Map.put(sitemap, page.url, page)
      {:ok, new_sitemap}
    end
  end

  def to_json do
    Agent.get __MODULE__, fn sitemap ->
      pages = Map.values(sitemap)
      {:ok, json} = Poison.encode(pages)
      json
    end
  end
end
