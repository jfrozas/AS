defmodule Cliente.ComprarCesta do
  use GenServer

  @moduledoc """
  Modulo que permite la compra de la cesta del cliente.
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
  Maneja la funcion de comprar_cesta.
  Usa dos funciones auxiliares: verificar_stock y comprar_cesta_aux.
  Primero verifica el stock de todos los productos en la cesta usando verificar_stock (Si algún producto no dispone de stock, se devuelve un :reply con :sin_stock).
  Una vez verificados, se llama a comprar_cesta_aux.
  Esta recorre toda la cesta, y por cada producto, accede a la BD par restarle las unidades que se compran de este al stock.
  Tras esto, se vacía la cesta y actualiza el agente, y se devuelve un :reply con la cesta, además del state.
  """
  def handle_call({:comprar_cesta, client_pid}, _from, state) do
    cesta =
      Agent.get(:cestas, fn cestas ->
        Map.get(cestas, client_pid, [])
      end)

    case verificar_stock(cesta) do
      :error ->
        {:reply, :sin_stock, state}

      :ok ->
        comprar_cesta_aux(cesta)

        Agent.update(:cestas, fn cestas ->
          Map.put(cestas, client_pid, [])
        end)

        {:reply, cesta, state}
    end
  end

  defp verificar_stock([]), do: :ok

  defp verificar_stock([producto | tail]) do
    stock = Fic_sports.Products.get_product_by_id(producto.id).stock

    if producto.units > stock do
      IO.puts("No existe suficiente stock del producto: #{producto.name}")
      :error
    else
      verificar_stock(tail)
    end
  end

  defp comprar_cesta_aux([]), do: :ok

  defp comprar_cesta_aux([producto | tail]) do
    stock = Fic_sports.Products.get_product_by_id(producto.id).stock

    Fic_sports.Products.edit_element(producto.id, %{
      stock: stock - producto.units,
      price: producto.price
    })

    comprar_cesta_aux(tail)
  end
end
