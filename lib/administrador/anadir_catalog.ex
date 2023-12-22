defmodule Administrador.AnadirCatalog do
  use GenServer

  @moduledoc """
  Módulo que permite la adición de elementos a la BD.
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
  Maneja la funcion de anadir_catalogo.
  Llama a Fic_sports.Products.add_element para añadir un elemento a la BD.
  En la reply:
  - Si es ok, se amnda un :reply con el item añadido
  - Si hay un info, se maneja el error haciendo pattern-matching al mensaje
  """
  def handle_call({:anadir_catalogo, element}, _from, state) do
    reply = Fic_sports.Products.add_element(element)

    case reply do
      {:ok, item} ->
        {:reply, item, state}

      {_, info} ->
        {:reply,
         case elem(hd(info.errors), 0) do
           :name -> :nombre_invalido
           :price -> :precio_invalido
         end, state}
    end
  end
end
