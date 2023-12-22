defmodule Cliente.EliminarCesta do
  use GenServer

  @moduledoc """
  Modulo que permite la eliminación de un elemento de la cesta del cliente.
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
  Maneja la funcion de eliminar_cesta.
  Primero comprueba si la cesta está vacía, y si este caso se da, devuelve un :reply con :cesta_vacia.
  Después, busca el elemento usando el element_id.
  Si el producto no se encuentra en la cesta, o no hay suficientes unidades en la cesta para eliminar, se devuelve un :reply con su mensaje correspondiente (:no_esta_en_cesta o :insuficientes_uds)
  Después, llama a la función auxiliar actualizar_cesta, que elimina esas unidades de la cesta (O el producto, si las unidades en la cesta son las mismas que las unidades a eliminar)
  Tras esto, se hace un update del agente, y se evuelve un :reply con la nueva cesta y el state.
  """
  def handle_call({:eliminar_cesta, client_pid, element_id, units}, _from, state) do
    cesta =
      Agent.get(:cestas, fn cestas ->
        Map.get(cestas, client_pid, [])
      end)

    if cesta == [] do
      {:reply, :cesta_vacia, state}
    else
      producto = Enum.find(cesta, fn p -> p.id == element_id end)

      if is_nil(producto) do
        IO.puts("Error, no se encuentra el producto con id #{element_id} en la cesta")
        {:reply, :no_esta_en_cesta, state}
      else
        if producto.units < units do
          IO.puts(
            "No hay suficientes unidades en la cesta para eliminar. Las unidades disponibles son: #{producto.units}"
          )

          {:reply, :insuficientes_uds, state}
        else
          nueva_cesta = actualizar_cesta(cesta, producto, units)

          Agent.update(:cestas, fn cestas ->
            Map.put(cestas, client_pid, nueva_cesta)
          end)

          {:reply, nueva_cesta, state}
        end
      end
    end
  end

  defp actualizar_cesta(cesta, producto, units) do
    if producto.units == units do
      List.delete(cesta, producto)
    else
      producto_actualizado = Map.put(producto, :units, producto.units - units)

      Enum.map(cesta, fn p ->
        if p.id == producto.id, do: producto_actualizado, else: p
      end)
    end
  end
end
