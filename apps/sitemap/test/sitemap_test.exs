defmodule SitemapTest do
  use ExUnit.Case
  alias SiteMap.Page

  test "add page to sitemap" do
    page = %Page{
      url: "http://example.com",
      images: ["http://image1.jpg"],
      sites: ["http://example.com/about"],
    }
    SiteMap.add_page(page)

    assert SiteMap.has_url?(page.url) == true
  end

  test "get page when it doesn't exist" do
    url = "http://example.fail"
    assert SiteMap.has_url?(url) == false
  end

end
