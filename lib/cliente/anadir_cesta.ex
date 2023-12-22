defmodule Cliente.AnadirCesta do
  use GenServer

  @moduledoc """
  Módulo que permite la adición de elementos a la cesta del cliente.
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
  Maneja la funcion de anadir_cesta.
  Lanza errores si units es 0, si el producto no existe o si el producto no tiene stock.
  Devuelve un :reply con el error o con el producto añadido, más el state.
  """
  def handle_call({:anadir_cesta, client_pid, element_id, units}, _from, state) do
    if units < 1 do
      IO.puts("El número de unidades añadidas a la cesta debe ser al menos 1")
      {:reply, :unidades_menor_1, state}
    else
      producto = Fic_sports.Products.get_product_by_id(element_id)

      if producto == :no_existe do
        IO.puts("El producto con id = #{element_id} no existe.")
        {:reply, :no_existe, state}
      else
        if producto.stock < units do
          IO.puts(
            "No hay suficiente stock para comprar. El stock disponible es: #{producto.stock}"
          )

          {:reply, :sin_stock, state}
        else
          elemento =
            producto
            |> Map.delete(:stock)
            |> Map.put(:units, units)

          Agent.update(:cestas, fn cestas ->
            cesta = Map.get(cestas, client_pid, [])
            elemento_cesta = Enum.find(cesta, fn p -> p.id == element_id end)

            nueva_cesta =
              if not is_nil(elemento_cesta) do
                cesta = List.delete(cesta, elemento_cesta)
                elemento_cesta = Map.put(elemento_cesta, :units, elemento_cesta.units + units)
                [elemento_cesta | cesta]
              else
                [elemento | cesta]
              end

            Map.put(cestas, client_pid, nueva_cesta)
          end)

          {:reply, %{id: element_id, units: units}, state}
        end
      end
    end
  end
end
