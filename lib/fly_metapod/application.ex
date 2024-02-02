defmodule FlyMetapod.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FlyMetapodWeb.Telemetry,
      FlyMetapod.Repo,
      {DNSCluster, query: Application.get_env(:fly_metapod, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FlyMetapod.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FlyMetapod.Finch},
      # Start a worker by calling: FlyMetapod.Worker.start_link(arg)
      # {FlyMetapod.Worker, arg},
      # Start to serve requests, typically the last entry
      FlyMetapodWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlyMetapod.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlyMetapodWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
