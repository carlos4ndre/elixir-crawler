defmodule CrawlerTest do
  use ExUnit.Case
  doctest Crawler

  import Crawler.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"])     == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "url parameter is properly parsed" do
    assert parse_args(["http://example.com"]) == { "http://example.com" }
  end
end
