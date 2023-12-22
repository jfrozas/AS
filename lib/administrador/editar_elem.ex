defmodule Administrador.EditarElem do
  use GenServer

  @moduledoc """
  Módulo que permite la edición de elementos a la BD.
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
  Maneja la funcion de editar_elemento.
  Llama a Fic_sports.Products.edit_element para editar un elemento de la BD.
  En la reply: devuelve un :reply con el item editado.
  """
  def handle_call({:editar_elemento, element_id, new_element}, _from, state) do
    {_, item} = Fic_sports.Products.edit_element(element_id, new_element)
    {:reply, item, state}
  end
end
