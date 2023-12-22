defmodule Cliente.VerCesta do
  use GenServer

  @moduledoc """
  Modulo que permite la visualización de la cesta del cliente.
  Contiene su propio GenServer con las funciones start_link, stop, init, handle_call
  """

  @doc """
  Inicia un nuevo proceso del GenServer.
  """
  @spec start_link(list(term())) :: {:ok, pid()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Mata el proceso del GenServer.
  """
  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  @doc """
  Configura el estado inicial del GenServer con los argumentos dados.
  """
  def init(init_arg) do
    {:ok, init_arg}
  end

  @doc """
  Maneja la funcion de ver_cesta.
  Coge la cesta del cliente, y la muestra por pantalla.
  Después, hace un :reply con la cesta y el state
  """
  def handle_call({:ver_cesta, client_pid}, _from, state) do
    cesta =
      Agent.get(:cestas, fn cestas ->
        Map.get(cestas, client_pid, [])
      end)
    {:reply, cesta, state}
  end
end
