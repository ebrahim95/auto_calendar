defmodule AutoCalendar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AutoCalendarWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:auto_calendar, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AutoCalendar.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AutoCalendar.Finch},
      # Start a worker by calling: AutoCalendar.Worker.start_link(arg)
      # {AutoCalendar.Worker, arg},
      # Start to serve requests, typically the last entry
      AutoCalendarWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AutoCalendar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AutoCalendarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
