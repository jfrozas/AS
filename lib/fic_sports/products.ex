defmodule Fic_sports.Products do
  use Ecto.Schema
  import Ecto.Query

  schema "products" do
    field(:name, :string)
    field(:category, :string)
    field(:price, :float)
    field(:brand, :string)
    field(:stock, :integer)
  end

  def changeset(product, params \\ %{}) do
    product
    |> Ecto.Changeset.cast(params, [:name, :category, :price, :brand, :stock])
    |> Ecto.Changeset.validate_required([:name, :price])
  end

  def get_product_by_id(element_id) do
    product = Fic_sports.Repo.get(Fic_sports.Products, element_id)

    case product do
      nil ->
        IO.puts("El producto con ID #{element_id} no existe en la base de datos.")
        :no_existe

      _ ->
        product
    end
  end

  # Funciones para trabajar sobre la BBDD

  def get_catalog_data(num_elements \\ :all) do
    query =
      if num_elements == :all do
        from(p in Fic_sports.Products,
          where: p.stock > 0,
          select: %{id: p.id, name: p.name, category: p.category, brand: p.brand, price: p.price},
          order_by: p.id
        )
      else
        from(p in Fic_sports.Products,
          where: p.stock > 0,
          select: %{id: p.id, name: p.name, category: p.category, brand: p.brand, price: p.price},
          limit: ^num_elements,
          order_by: p.id
        )
      end

    query
    |> Fic_sports.Repo.all()
  end

  def get_catalog_data_admin(num_elements \\ :all) do
    query =
      if num_elements == :all do
        from(p in Fic_sports.Products,
          select: %{
            id: p.id,
            name: p.name,
            category: p.category,
            brand: p.brand,
            stock: p.stock,
            price: p.price
          },
          order_by: p.id
        )
      else
        from(p in Fic_sports.Products,
          select: %{
            id: p.id,
            name: p.name,
            category: p.category,
            brand: p.brand,
            stock: p.stock,
            price: p.price
          },
          limit: ^num_elements,
          order_by: p.id
        )
      end

    query
    |> Fic_sports.Repo.all()
  end

  def add_element(element_params) do
    element_params =
      if Map.get(element_params, :price) < 0 do
        Map.delete(element_params, :price)
      else
        element_params
      end

    element_params =
      element_params
      |> Map.update(:stock, 0, &max(&1, 0))

    try do
      %Fic_sports.Products{}
      |> changeset(element_params)
      |> Fic_sports.Repo.insert()
    catch
      _ -> :error
    end
  end

  def delete_element(id) do
    product = Fic_sports.Repo.get(Fic_sports.Products, id)

    case product do
      nil ->
        IO.puts("El producto con ID #{id} no existe en la base de datos.")
        {:reply, :no_existe}

      _ ->
        try do
          Fic_sports.Repo.delete(product)
        catch
          Ecto.Repo.SchemaError ->
            IO.puts("La estructura del producto es inválida.")

          Ecto.StaleEntryError ->
            IO.puts("El producto ya ha sido eliminado de la base de datos.")
        end
    end
  end

  def edit_element(id, new_params) do
    product = Fic_sports.Repo.get(Fic_sports.Products, id)

    product_stock = if new_params.stock < 0, do: 0, else: new_params.stock
    product_price = if new_params.price < 0, do: 0, else: new_params.price

    case product do
      nil ->
        IO.puts("El producto con ID #{id} no existe en la base de datos.")
        {:reply, :no_existe}

      _ ->
        updated_product =
          product
          |> Fic_sports.Products.changeset(%{
            new_params
            | stock: product_stock,
              price: product_price
          })
          |> Fic_sports.Repo.update()

        case updated_product do
          {:ok, _} ->
            IO.puts("Producto con ID #{id} editado de manera exitosa.")

          {:error, _} ->
            IO.puts("No se pudo editar el producto.")
        end

        updated_product
    end
  end
end
