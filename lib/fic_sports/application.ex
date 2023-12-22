defmodule FicSports.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    args = System.argv()
    user = List.first(args)

    children =
      case user do
        param when param in ["cliente", "admin"] ->
          []
        param when param in ["app", "test"] ->
          Agent.start_link(fn -> %{} end, name: :cestas)

          [
            Fic_sports.Repo,
            Cliente.ClienteDir,
            Cliente.AnadirCesta,
            Cliente.CancelarCesta,
            Cliente.ComprarCesta,
            Cliente.EliminarCesta,
            Cliente.VerCesta,
            Administrador.AdminDir,
            Administrador.AnadirCatalog,
            Administrador.EditarElem,
            Administrador.EliminarCatalog,
            VerCatalog
            # Starts a worker by calling: FicSports.Worker.start_link(arg)
            # {FicSports.Worker, arg}
          ]

      end

    opts = [strategy: :one_for_one, name: FicSports.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
