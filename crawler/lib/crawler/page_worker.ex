defmodule Crawler.PageWorker do
  require Logger
  use GenServer
  alias Crawler.HTMLParser

  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(@me, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:fetch, url}, _from, state) do
    if SiteMap.has_url?(url) do
      Logger.info("Already processed url #{url}")
      {:reply, nil, state}
    else
      Logger.info("Process url #{url}")
      page = HTMLParser.parse_page(url)
      {:reply, page, state}
    end
  end
end
