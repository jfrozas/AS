defmodule Cliente.CancelarCesta do
  use GenServer

  @moduledoc """
  Modulo que permite la eliminación de la cesta del cliente.
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
  Maneja la funcion de cancelar_cesta.
  Llama al Agent.update para sustituir la cesta por una vacía.
  Devuelve un :reply, con la cesta actual, más el state.
  """
  def handle_call({:cancelar_cesta, client_pid}, _from, state) do
    Agent.update(:cestas, fn cestas ->
      Map.put(cestas, client_pid, [])
    end)

    cesta =
      Agent.get(:cestas, fn cestas ->
        Map.get(cestas, client_pid, [])
      end)

    {:reply, cesta, state}
  end
end
