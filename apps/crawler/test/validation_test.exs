defmodule ValidationTest do
  use ExUnit.Case
  import Crawler.Validation, only: [url_valid?: 1]

  test "url is valid" do
    urls = [
      "http://example.com",
      "https://example.com",
      "https://example.com/elixir",
    ]

    for url <- urls do
      assert url_valid?(url) == true
    end
  end

  test "url is invalid" do
    urls = [
      "example.com",
      "ftp://example.com",
      "http://",
      "://example.com",
      "#example.com",
    ]

    for url <- urls do
      IO.inspect url
      assert url_valid?(url) == false
    end
  end

end
