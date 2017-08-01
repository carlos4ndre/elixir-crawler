[![Travis build](https://secure.travis-ci.org/carlos4ndre/elixir-crawler.svg?branch=master
"Build Status")](https://travis-ci.org/carlos4ndre/elixir-crawler)
<a href="https://codeclimate.com/github/carlos4ndre/elixir-crawler"><img src="https://codeclimate.com/github/carlos4ndre/elixir-crawler/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/carlos4ndre/elixir-crawler"><img src="https://codeclimate.com/github/carlos4ndre/elixir-crawler/badges/issue_count.svg" /></a>

# Elixir Crawler
Web Crawler written in Elixir

# Usage
Compile and crawl!
```
$ cd apps/cli
$ mix deps.get
$ mix escript.build
$ ./crawler http://bucketheadpikes.com
```

Or use docker to run it:
```
$ mix docker.build
$ mix docker.release
$ docker run -it --rm elixir-crawler:release crawler "http://bucketheadpikes.com"
```
