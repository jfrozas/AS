defmodule Cliente.ClienteDir do
  use GenServer

  @moduledoc """
  Modulo que contiene el directorio del cliente.
  Contiene su propio GenServer con las funciones start_link, stop, init, handle_call, además de las llamadas de ver_catalogo, ver_cesta, anadir_cesta, eliminar_cesta, comprar_cesta y cancelar_cesta.
  """

  @spec start_link(list(term())) :: {:ok, pid()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: {:global, __MODULE__})
  end

  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  def ver_catalogo(), do: GenServer.call({:global, __MODULE__}, :ver_catalogo)
  def ver_catalogo(limit), do: GenServer.call({:global, __MODULE__}, {:ver_catalogo, limit})

  def ver_cesta(pid) do
    GenServer.call({:global, __MODULE__}, {:ver_cesta, pid})
  end

  def anadir_cesta(element_id, units \\ 1, pid) do
    GenServer.call({:global, __MODULE__}, {:anadir_cesta, pid, element_id, units})
  end

  def eliminar_cesta(element_id, units, pid) do
    GenServer.call({:global, __MODULE__}, {:eliminar_cesta, pid, element_id, units})
  end

  def comprar_cesta(pid) do
    GenServer.call({:global, __MODULE__}, {:comprar_cesta, pid})
  end

  def cancelar_cesta(pid) do
    GenServer.call({:global, __MODULE__}, {:cancelar_cesta, pid})
  end

  # Callbacks
  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call(:ver_catalogo, _, state) do
    reply = GenServer.call(VerCatalog, :ver_catalogo)
    {:reply, reply, state}
  end

  def handle_call({:ver_catalogo, limit}, _, state) do
    reply = GenServer.call(VerCatalog, {:ver_catalogo, limit})
    {:reply, reply, state}
  end

  def handle_call({:ver_cesta, pid}, _, state) do
    reply = GenServer.call(Cliente.VerCesta, {:ver_cesta, pid})
    {:reply, reply, state}
  end

  def handle_call({:anadir_cesta, pid, element_id, units}, _, state) do
    reply = GenServer.call(Cliente.AnadirCesta, {:anadir_cesta, pid, element_id, units})
    {:reply, reply, state}
  end

  def handle_call({:eliminar_cesta, pid, element_id, units}, _, state) do
    reply = GenServer.call(Cliente.EliminarCesta, {:eliminar_cesta, pid, element_id, units})
    {:reply, reply, state}
  end

  def handle_call({:comprar_cesta, pid}, _, state) do
    reply = GenServer.call(Cliente.ComprarCesta, {:comprar_cesta, pid})
    {:reply, reply, state}
  end

  def handle_call({:cancelar_cesta, pid}, _, state) do
    reply = GenServer.call(Cliente.CancelarCesta, {:cancelar_cesta, pid})
    {:reply, reply, state}
  end
end
