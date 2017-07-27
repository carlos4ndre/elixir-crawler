defmodule SitemapTest do
  use ExUnit.Case
  alias SiteMap.Page

  test "add page to sitemap" do
    page = %Page{url: "http://example.com"}
    SiteMap.add_page(page)

    assert SiteMap.has_page?(page) == true
  end

  test "get page when it doesn't exist" do
    page = %Page{url: "http://example.fail"}

    assert SiteMap.has_page?(page) == false
  end

  @tag :capture_log
  test "pages with invalid url are not added to sitemap" do
    invalid_pages = [
      %Page{url: ""},
      %Page{url: "."},
      %Page{url: ".com"},
      %Page{url: "example."},
      %Page{url: "example.com"},
      %Page{url: "dog://example.com"},
    ]

    for page <- invalid_pages do
      SiteMap.add_page(page)
      assert SiteMap.has_page?(page) == false
    end
  end
end
