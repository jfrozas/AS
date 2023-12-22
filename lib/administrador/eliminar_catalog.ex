defmodule Administrador.EliminarCatalog do
  use GenServer

  @moduledoc """
  Módulo que permite la eliminación de elementos a la BD.
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
  Maneja la funcion de eliminar_catalogo.
  Llama a Fic_sports.Products.delete_element para eliminar un elemento de la BD.
  En la reply: devuelve un :reply con el item editado.
  """
  def handle_call({:eliminar_catalogo, element_id}, _from, state) do
    {_status, item} = Fic_sports.Products.delete_element(element_id)
    {:reply, item, state}
  end
end
