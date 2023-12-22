defmodule Administrador.AdminDir do
  use GenServer

  @moduledoc """
  Modulo que contiene el directorio del cliente.
  Contiene su propio GenServer con las funciones start_link, stop, init, handle_call, además de las llamadas de ver_catalogo, anadir_elemento, eliminar_elemento y editar_elemento.
  """

  @spec start_link(list(term())) :: {:ok, pid()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: {:global, __MODULE__})
  end

  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  def ver_catalogo(), do: GenServer.call({:global, __MODULE__}, :ver_catalogo_admin)
  def ver_catalogo(limit), do: GenServer.call({:global, __MODULE__}, {:ver_catalogo_admin, limit})

  def anadir_elemento(params) do
    GenServer.call({:global, __MODULE__}, {:anadir_catalogo, params})
  end

  def eliminar_elemento(element_id) do
    GenServer.call({:global, __MODULE__}, {:eliminar_catalogo, element_id})
  end

  def editar_elemento(element_id, params) do
    GenServer.call({:global, __MODULE__}, {:editar_elemento, element_id, params})
  end

  # Callbacks
  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_call(:ver_catalogo_admin, _, state) do
    reply = GenServer.call(VerCatalog, :ver_catalogo_admin)
    {:reply, reply, state}
  end

  def handle_call({:ver_catalogo_admin, limit}, _, state) do
    reply = GenServer.call(VerCatalog, {:ver_catalogo_admin, limit})
    {:reply, reply, state}
  end

  def handle_call({:anadir_catalogo, params}, _, state) do
    reply = GenServer.call(Administrador.AnadirCatalog, {:anadir_catalogo, params})
    {:reply, reply, state}
  end

  def handle_call({:eliminar_catalogo, element_id}, _, state) do
    reply = GenServer.call(Administrador.EliminarCatalog, {:eliminar_catalogo, element_id})
    {:reply, reply, state}
  end

  def handle_call({:editar_elemento, element_id, params}, _, state) do
    reply = GenServer.call(Administrador.EditarElem, {:editar_elemento, element_id, params})
    {:reply, reply, state}
  end
end
