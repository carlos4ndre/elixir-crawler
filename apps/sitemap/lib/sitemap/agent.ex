defmodule SiteMap.Agent do
  require Logger

  @me :sitemap

  def start_link do
    Agent.start_link(fn -> %{} end, name: @me)
  end

  def has_url?(url) do
    Agent.get(@me, fn sitemap ->
      Map.has_key?(sitemap, url)
    end)
  end

  def add_page(page) do
    Agent.get_and_update(@me, fn sitemap ->
      new_sitemap = Map.put(sitemap, page.url, page)
      {:ok, new_sitemap}
    end)
  end

  def to_json() do
    Agent.get(@me, fn sitemap ->
      pages = Map.values(sitemap)
      {:ok, json} = Poison.encode(pages)
      json
    end)
  end
end
