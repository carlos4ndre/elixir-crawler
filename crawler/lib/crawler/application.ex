defmodule Crawler.Application do
  use Application
  alias Crawler.PageWorker

  defp pool_name() do
    :page_pool
  end

  defp poolboy_config() do
    [{:name, {:local, pool_name()}},
      {:worker_module, PageWorker},
      {:size, 5},
      {:max_overflow, 2}]
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config(), [])
    ]

    options = [
      name: Crawler.Supervisor,
      strategy: :one_for_one,
    ]

    Supervisor.start_link(children, options)
  end
end
