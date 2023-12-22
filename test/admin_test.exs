defmodule AdminTest do
  use ExUnit.Case
  alias FicSports
  alias Administrador

  setup_all do
    Fic_sports.CSVImporter.reset_bd("bd.csv")
    {:ok, initial_state: %{}}
  end

  # ************************************** VER CATALOGO ****************************************

  test "Ver el catalogo sin límite de elementos" do
    assert Administrador.AdminDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 stock: 6,
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 stock: 3,
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 stock: 3,
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 stock: 10,
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 stock: 6,
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 stock: 8,
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 stock: 3,
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 stock: 1,
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 stock: 8,
                 brand: "Puma",
                 price: 19.99
               }
             ]
  end

  test "Ver el catalogo con límite de elementos" do
    assert Administrador.AdminDir.ver_catalogo(2) ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 brand: "Mizuno",
                 price: 39.99,
                 stock: 6
               }
             ]
  end

  test "Ver el catalogo con límite de elementos inválido" do
    assert Administrador.AdminDir.ver_catalogo(0) == :error
    assert Administrador.AdminDir.ver_catalogo(-1) == :error
  end

  # ************************************** AÑADIR ELEMENTO AL CATALOGO ****************************************

  test "Añadir elemento al catalogo" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        brand: "Reebok",
        category: "Running",
        name: "Termical Shirt",
        stock: 15,
        price: 4.49
      })

    assert Administrador.AdminDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 stock: 6,
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 stock: 3,
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 stock: 3,
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 stock: 10,
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 stock: 6,
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 stock: 8,
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 stock: 3,
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 stock: 1,
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 stock: 8,
                 brand: "Puma",
                 price: 19.99
               },
               %{
                 id: nuevo_elemento.id,
                 name: "Termical Shirt",
                 category: "Running",
                 stock: 15,
                 brand: "Reebok",
                 price: 4.49
               }
             ]

    # Volvemos a dejar la BD como estaba anteriormente
    Administrador.AdminDir.eliminar_elemento(nuevo_elemento.id)
  end

  test "Añadir elemento al catalogo con nombre vacio" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        brand: "Reebok",
        category: "Running",
        stock: 15,
        price: 4.49
      })

    assert nuevo_elemento == :nombre_invalido
  end

  test "Añadir elemento al catalogo con precio vacio" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        name: "DryMove Sports Shirt",
        brand: "Reebok",
        category: "Running",
        stock: 15
      })

    assert nuevo_elemento == :precio_invalido
  end

  test "Añadir elemento al catalogo con precio negativo" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        name: "DryMove Sports Shirt",
        price: -19.99,
        brand: "Reebok",
        category: "Running",
        stock: 15
      })

    assert nuevo_elemento == :precio_invalido
  end

  test "Añadir elemento al catalogo con stock vacio" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        brand: "Reebok",
        category: "Running",
        name: "Termical Shirt",
        price: 4.49
      })

    assert Administrador.AdminDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 stock: 6,
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 stock: 3,
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 stock: 3,
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 stock: 10,
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 stock: 6,
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 stock: 8,
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 stock: 3,
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 stock: 1,
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 stock: 8,
                 brand: "Puma",
                 price: 19.99
               },
               %{
                 id: nuevo_elemento.id,
                 name: "Termical Shirt",
                 category: "Running",
                 stock: 0,
                 brand: "Reebok",
                 price: 4.49
               }
             ]

    # Volvemos a dejar la BD como estaba anteriormente
    Administrador.AdminDir.eliminar_elemento(nuevo_elemento.id)
  end

  test "Añadir elemento al catalogo con stock negativo" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        brand: "Reebok",
        category: "Running",
        stock: -10,
        name: "Termical Shirt",
        price: 4.49
      })

    assert Administrador.AdminDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 stock: 6,
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 stock: 3,
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 stock: 3,
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 stock: 10,
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 stock: 6,
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 stock: 8,
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 stock: 3,
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 stock: 1,
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 stock: 8,
                 brand: "Puma",
                 price: 19.99
               },
               %{
                 id: nuevo_elemento.id,
                 name: "Termical Shirt",
                 category: "Running",
                 stock: 0,
                 brand: "Reebok",
                 price: 4.49
               }
             ]

    # Volvemos a dejar la BD como estaba anteriormente
    Administrador.AdminDir.eliminar_elemento(nuevo_elemento.id)
  end

  test "Añadir elemento al catalogo con marca vacia" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        category: "Running",
        stock: 15,
        name: "Termical Shirt",
        price: 4.49
      })

    assert Administrador.AdminDir.ver_catalogo() ==
             [
               %{
                 id: 1,
                 name: "Regular Fit Lightweight Outdoor Jacket",
                 category: "Tennis",
                 stock: 4,
                 brand: "Mizuno",
                 price: 74.99
               },
               %{
                 id: 2,
                 name: "DryMove Sports Joggers",
                 category: "Ski",
                 stock: 6,
                 brand: "Mizuno",
                 price: 39.99
               },
               %{
                 id: 3,
                 name: "DryMove Sports Hoodie",
                 category: "Tennis",
                 stock: 3,
                 brand: "Quechua",
                 price: 64.99
               },
               %{
                 id: 4,
                 name: "Regular Fit Padded Vest",
                 category: "Baseball",
                 stock: 3,
                 brand: "Adidas",
                 price: 49.99
               },
               %{
                 id: 5,
                 name: "DryMove Sports Shirt",
                 category: "Basketball",
                 stock: 10,
                 brand: "Quechua",
                 price: 12.99
               },
               %{
                 id: 6,
                 name: "DryMove Sports Joggers",
                 category: "Snowboard",
                 stock: 6,
                 brand: "Quechua",
                 price: 39.99
               },
               %{
                 id: 7,
                 name: "DryMove Sports Shirt",
                 category: "Football",
                 stock: 8,
                 brand: "Nike",
                 price: 19.99
               },
               %{
                 id: 8,
                 name: "Running Pants",
                 category: "Football",
                 stock: 3,
                 brand: "Jordan",
                 price: 34.99
               },
               %{
                 id: 9,
                 name: "StormMove 2.5-layer Parka",
                 category: "Ski",
                 stock: 1,
                 brand: "Asics",
                 price: 149.0
               },
               %{
                 id: 10,
                 name: "DryMove Sports Shirt",
                 category: "Paddel",
                 stock: 8,
                 brand: "Puma",
                 price: 19.99
               },
               %{
                 id: nuevo_elemento.id,
                 name: "Termical Shirt",
                 category: "Running",
                 stock: 15,
                 brand: nil,
                 price: 4.49
               }
             ]

    # Volvemos a dejar la BD como estaba anteriormente
    Administrador.AdminDir.eliminar_elemento(nuevo_elemento.id)
  end

  # ************************************** ELIMINAR ELEMENTO DEL CATALOGO ****************************************

  test "Eliminar elemento que no existe del catalogo" do
    assert Administrador.AdminDir.eliminar_elemento(11) == :no_existe
  end

  test "Eliminar elemento del catalogo" do
    nuevo_elemento =
      Administrador.AdminDir.anadir_elemento(%{
        brand: "Reebok",
        category: "Running",
        name: "Termical Shirt",
        stock: 15,
        price: 4.49
      })

    Administrador.AdminDir.eliminar_elemento(nuevo_elemento.id)
    assert length(Administrador.AdminDir.ver_catalogo()) == 10
  end

  # ************************************** EDITAR ELEMENTO DEL CATALOGO ****************************************

  test "Editar elemento inexistente" do
    assert Administrador.AdminDir.editar_elemento(100, %{
             brand: "Mizuno",
             category: "Tennis",
             name: "Regular Fit Lightweight Outdoor Jacket",
             price: 74.99,
             stock: 1
           }) == :no_existe
  end

  test "Editar elemento poniendo stock negativo" do
    elemento_editado =
      Administrador.AdminDir.editar_elemento(1, %{
        name: "Regular Fit Lightweight Outdoor Jacket",
        category: "Tennis",
        stock: -10,
        brand: "Mizuno",
        price: 74.99
      })

    assert elemento_editado.stock == 0

    # Dejamos el elemento como estaba
    Administrador.AdminDir.editar_elemento(1, %{
      name: "Regular Fit Lightweight Outdoor Jacket",
      category: "Tennis",
      stock: 4,
      brand: "Mizuno",
      price: 74.99
    })
  end

  test "Editar elemento poniendo precio negativo" do
    elemento_editado =
      Administrador.AdminDir.editar_elemento(1, %{
        name: "Regular Fit Lightweight Outdoor Jacket",
        category: "Tennis",
        stock: 4,
        brand: "Mizuno",
        price: -1.19
      })

    assert elemento_editado.price == 0

    # Dejamos el elemento como estaba
    Administrador.AdminDir.editar_elemento(1, %{
      name: "Regular Fit Lightweight Outdoor Jacket",
      category: "Tennis",
      stock: 4,
      brand: "Mizuno",
      price: 74.99
    })
  end

  test "Editar elemento poniendo nombre vacío" do
    product =
      Administrador.AdminDir.editar_elemento(1, %{
        category: "Football",
        stock: 15,
        brand: "Adidas",
        price: 14.49
      })

    assert product.name == "Regular Fit Lightweight Outdoor Jacket"

    # Dejamos el elemento como estaba
    Administrador.AdminDir.editar_elemento(1, %{
      name: "Regular Fit Lightweight Outdoor Jacket",
      category: "Tennis",
      stock: 4,
      brand: "Mizuno",
      price: 74.99
    })
  end

  test "Editar solo algunos parametros del elemento" do
    product =
      Administrador.AdminDir.editar_elemento(1, %{brand: "Adidas", price: 14.49, stock: 15})

    assert product.name == "Regular Fit Lightweight Outdoor Jacket"
    assert product.category == "Tennis"

    # Dejamos el elemento como estaba
    Administrador.AdminDir.editar_elemento(1, %{
      name: "Regular Fit Lightweight Outdoor Jacket",
      category: "Tennis",
      stock: 4,
      brand: "Mizuno",
      price: 74.99
    })
  end

  test "Editar elemento poniendo parametros correctos" do
    product =
      Administrador.AdminDir.editar_elemento(1, %{
        name: "NBA Basket",
        brand: "Nike",
        price: 149.99,
        stock: 1,
        category: "Basketball"
      })

    assert product.name == "NBA Basket"
    assert product.brand == "Nike"
    assert product.price == 149.99
    assert product.stock == 1
    assert product.category == "Basketball"

    # Dejamos el elemento como estaba
    Administrador.AdminDir.editar_elemento(1, %{
      name: "Regular Fit Lightweight Outdoor Jacket",
      category: "Tennis",
      stock: 4,
      brand: "Mizuno",
      price: 74.99
    })
  end
end
