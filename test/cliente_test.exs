defmodule ClienteTest do
  use ExUnit.Case
  alias FicSports
  alias Cliente

  setup_all do
    Fic_sports.CSVImporter.reset_bd("bd.csv")
    {:ok, initial_state: %{}}
  end

  # ************************************** VER CATALOGO ****************************************

  test "Ver el catalogo sin límite de elementos" do
    assert Cliente.ClienteDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 brand: "Puma",
                 price: 19.99
               }
             ]
  end

  test "Ver el catalogo con límite de elementos" do
    assert Cliente.ClienteDir.ver_catalogo(3) ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 brand: "Quechua",
                 price: 64.99
               }
             ]
  end

  test "Ver el catalogo con límite de elementos inválido" do
    assert Cliente.ClienteDir.ver_catalogo(-1) == :error
    assert Cliente.ClienteDir.ver_catalogo(0) == :error
  end

  # ************************************** VER CESTA ****************************************

  test "Ver cesta vacia" do
    assert Cliente.ClienteDir.ver_cesta(self()) == []
  end

  test "Ver cesta con varios elementos" do
    Cliente.ClienteDir.anadir_cesta(1, 2, self())
    Cliente.ClienteDir.anadir_cesta(2, 4, self())

    # Eliminamos el campo __meta__ y pasamos de struct a mapa
    cesta =
      Cliente.ClienteDir.ver_cesta(self())
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))

    assert cesta ==
             [
               %{
                 id: 2,
                 units: 4,
                 brand: "Mizuno",
                 category: "Ski",
                 name: "DryMove Sports Joggers",
                 price: 39.99
               },
               %{
                 id: 1,
                 units: 2,
                 brand: "Mizuno",
                 category: "Tennis",
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 price: 74.99
               }
             ]
  end

  # ************************************** AÑADIR ELEMENTO A LA CESTA ****************************************

  test "Añadir elemento a la cesta vacia" do
    assert Cliente.ClienteDir.anadir_cesta(1, 2, self()) == %{id: 1, units: 2}
  end

  test "Añadir elemento a la cesta vacia usando las unidades por defecto" do
    assert Cliente.ClienteDir.anadir_cesta(1, self()) == %{id: 1, units: 1}
  end

  test "Añadir elemento inexistente a la cesta" do
    assert Cliente.ClienteDir.anadir_cesta(20, 2, self()) == :no_existe
  end

  test "Añadir elemento a la cesta del que no queda stock" do
    assert Cliente.ClienteDir.anadir_cesta(9, 3, self()) == :sin_stock
  end

  test "Añadir 0 unidades de un elemento a la cesta" do
    assert Cliente.ClienteDir.anadir_cesta(1, 0, self()) == :unidades_menor_1
  end

  test "Añadir elemento ya existente en la cesta" do
    Cliente.ClienteDir.anadir_cesta(5, 2, self())
    Cliente.ClienteDir.anadir_cesta(5, 6, self())

    # Eliminamos el campo __meta__ y pasamos de struct a mapa
    cesta =
      Cliente.ClienteDir.ver_cesta(self())
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))

    assert cesta ==
             [
               %{
                 id: 5,
                 units: 8,
                 brand: "Quechua",
                 category: "Basketball",
                 name: "DryMove Sports Shirt",
                 price: 12.99
               }
             ]
  end

  # ************************************** ELIMINAR ELEMENTO DE LA CESTA ****************************************

  test "Eliminar un elemento de una cesta vacia" do
    assert Cliente.ClienteDir.eliminar_cesta(5, 2, self()) == :cesta_vacia
  end

  test "Eliminar un elemento que no aparece en la cesta" do
    Cliente.ClienteDir.anadir_cesta(5, 2, self())
    assert Cliente.ClienteDir.eliminar_cesta(1, 1, self()) == :no_esta_en_cesta
  end

  test "Eliminar un elemento de la cesta" do
    Cliente.ClienteDir.anadir_cesta(5, 2, self())
    assert Cliente.ClienteDir.eliminar_cesta(5, 2, self()) == []
  end

  test "Eliminar más unidades de un elemento de las existentes en la cesta" do
    Cliente.ClienteDir.anadir_cesta(5, 2, self())
    assert Cliente.ClienteDir.eliminar_cesta(5, 4, self()) == :insuficientes_uds
  end

  test "Eliminar un elemento, sin borrar todas sus unidades, de la cesta" do
    Cliente.ClienteDir.anadir_cesta(5, 8, self())

    # Eliminamos el campo __meta__ y pasamos de struct a mapa
    cesta_eliminada =
      Cliente.ClienteDir.eliminar_cesta(5, 2, self())
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))

    assert cesta_eliminada ==
             [
               %{
                 id: 5,
                 units: 6,
                 brand: "Quechua",
                 category: "Basketball",
                 name: "DryMove Sports Shirt",
                 price: 12.99
               }
             ]
  end

  # ************************************** CANCELAR CESTA ****************************************

  test "Cancelar una cesta vacia" do
    assert Cliente.ClienteDir.cancelar_cesta(self()) == []
  end

  test "Cancelar una cesta con varios elementos" do
    Cliente.ClienteDir.anadir_cesta(5, 8, self())
    Cliente.ClienteDir.anadir_cesta(1, 1, self())
    Cliente.ClienteDir.anadir_cesta(1, 1, self())
    assert Cliente.ClienteDir.cancelar_cesta(self()) == []
  end

  # ************************************** COMPRAR CESTA ****************************************

  test "Comprar una cesta vacía" do
    assert Cliente.ClienteDir.comprar_cesta(self()) == []
  end

  test "Comprar una cesta con varios elementos" do
    Cliente.ClienteDir.anadir_cesta(5, 8, self())
    Cliente.ClienteDir.anadir_cesta(1, 1, self())
    Cliente.ClienteDir.anadir_cesta(1, 1, self())

    cesta_comprada =
      Cliente.ClienteDir.comprar_cesta(self())
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.drop(&1, [:__meta__]))

    assert cesta_comprada ==
             [
               %{
                 id: 1,
                 units: 2,
                 brand: "Mizuno",
                 category: "Tennis",
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 price: 74.99
               },
               %{
                 id: 5,
                 units: 8,
                 brand: "Quechua",
                 category: "Basketball",
                 name: "DryMove Sports Shirt",
                 price: 12.99
               }
             ]

    # Volvemos a dejar la BD como estaba anteriormente
    Fic_sports.CSVImporter.reset_bd("bd.csv")

    assert Cliente.ClienteDir.ver_cesta(self()) == []
  end

  test "Comprar una cesta con varios elementos, sin stock" do
    Cliente.ClienteDir.anadir_cesta(1, 3, self())

    # Quitamos stock directamente de la BD
    Fic_sports.Products.edit_element(1, %{
      brand: "Mizuno",
      category: "Tennis",
      name: "Regular Fit Lightweight Outdoor Jacket",
      price: 74.99,
      stock: 1
    })

    assert Cliente.ClienteDir.comprar_cesta(self()) == :sin_stock

    # Volvemos a dejar la BD como estaba anteriormente
    Fic_sports.Products.edit_element(1, %{
      brand: "Mizuno",
      category: "Tennis",
      name: "Regular Fit Lightweight Outdoor Jacket",
      price: 74.99,
      stock: 4
    })
  end
end
