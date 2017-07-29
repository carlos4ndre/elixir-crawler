Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :";bly}$<2RtwLymTj/mRSwgcI(&Nf)}kDRmBM[fSnbLsXqk[K<ixkaSD]hBUc;@aX"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :")$XwDQHTMXdW8AK6okLPeNl:>8!EgB.6jiAtFAEDh`0sdanUb90xPu*KXx2&CFR6"
end

release :elixir_crawler do
  set version: "0.1.0"
  set applications: [
    :runtime_tools,
    cli: :permanent,
    crawler: :permanent,
    sitemap: :permanent
  ]
  set output_dir: './releases/elixir_crawler_app'
end

