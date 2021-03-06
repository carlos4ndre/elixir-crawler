defmodule SiteMap do
  alias SiteMap.Agent

  defdelegate has_url?(url), to: Agent
  defdelegate add_page(page), to: Agent
  defdelegate get_sitemap(), to: Agent
end
