defmodule VerCatalog do
  use GenServer

  @moduledoc """
  Módulo que permite la visualización de elementos de la BD.
  Contiene su propio GenServer con las funciones start_link, stop, init, handle_call
  Maneja las llamadas ver_catalogo y ver_catalogo_admin
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
  Maneja las llamadas {:ver_catalogo, limit}, :ver_catalogo, {:ver_catalogo_admin, limit} y :ver_catalogo_admin
  Accede a la BD y coge los limit elementos-todos los elementos dependiendo del caso
  En esos, coge los campos ["id", "name", "category", "brand", "price"] si es del cliente, o ["id", "name", "category", "stock", "brand", "price"] si es del admin.
  Printea los campos.
  Devuelve un :reply con el mapa de elementos.
  """
  def handle_call({:ver_catalogo, limit}, _from, state) do
    if limit < 1 do
      IO.puts("El numero de elementos a ver debe ser un entero positivo")
      {:reply, :error, state}
    else
      catalog_data = Fic_sports.Products.get_catalog_data(limit)
      {:reply, catalog_data, state}
    end
  end

  def handle_call(:ver_catalogo, _from, state) do
    catalog_data = Fic_sports.Products.get_catalog_data()
    {:reply, catalog_data, state}
  end

  def handle_call({:ver_catalogo_admin, limit}, _from, state) do
    if limit < 1 do
      IO.puts("El numero de elementos a ver debe ser un entero positivo")
      {:reply, :error, state}
    else
      catalog_data = Fic_sports.Products.get_catalog_data_admin(limit)
      {:reply, catalog_data, state}
    end
  end

  def handle_call(:ver_catalogo_admin, _from, state) do
    catalog_data = Fic_sports.Products.get_catalog_data_admin()
    {:reply, catalog_data, state}
  end
end
