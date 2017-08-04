["rel", "plugins", "*.exs"]
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"BCk0@*C1w5H>v$;E/%2q(k<?<UhU0&F;2L>a)~g`LIkP=I56WBH,x,6<o?|q{GpB"
end

environment :prod do
  set include_erts: false
  set include_src: false
  set cookie: :"P|cE?k&=2u.oI_oHAMx.,/VGikxLH:%2%Z=R4S,8*RDq8UXQ2[2kw57R]`qkf)05"
end

release :elixir_crawler do
  set version: "0.1.0"
  set applications: [
    :runtime_tools,
    cli: :permanent,
    crawler: :permanent,
    sitemap: :permanent
  ]
  set commands: [
    "crawler": "rel/commands/crawler.sh"
  ]
end

