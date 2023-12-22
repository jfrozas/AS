# Requisitos FIC_SPORTS

El proyecto consiste en una aplicación de una **tienda de venta de productos deportivos**. </br>
La aplicación será accesible tanto por clientes como por administradores.
Los primeros podrán, entre otras acciones, ver el catálogo, añadir elementos a su cesta, eliminar elementos de esta o comprarla.
Los administradores, por su parte, tendrán la capacidad de realizar modificaciones en el catálogo de la tienda.

La arquitectura a emplear en este trabajo será: **Arquitectura Cliente-Servidor**.

- [Requisitos funcionales y no funcionales](./doc/requisitos.md)

- Diagramas C4 del proyecto:
   - [Contexto](./doc/C4contexto.jpeg) 
   - [Contenedor](./doc/C4contenedor.jpeg) 
   - [Componente](./doc/C4componente.jpeg) 
   - [Código](./doc/C4codigo.jpeg)

## Uso del programa

### 1. Arrancar primero la terminal aplicacion:
```bash
iex --sname host -S mix run -- app
```

### 2. Arrancar los clientes/administradores:

Terminal de administrador: 
```bash
iex --sname admin -S mix run -- admin
Node.ping :"host@david-ThinkPad-L13-Yoga"
```
Terminal de cliente 1:
```bash
iex --sname client1 -S mix run -- cliente
Node.ping :"host@david-ThinkPad-L13-Yoga"
```
Terminal de cliente 2:
```bash
iex --sname client2 -S mix run -- cliente
Node.ping :"host@david-ThinkPad-L13-Yoga"
```

### 3. Comprobar que están conectados: 
Terminal de host:
```bash
Node.list
```

### 4. Disfrutar del programa 🤓👍

## Demostración de uso:
Admin:
```bash
Administrador.AdminDir.ver_catalogo()
Administrador.AdminDir.ver_catalogo(5)
Administrador.AdminDir.anadir_elemento(%{name: "Regular Fit Padded Vest", category: "Tennis", stock: 4, brand: "Mizuno", price: 19.99})
Cliente.ClienteDir.ver_catalogo()
Administrador.AdminDir.ver_catalogo()
Administrador.AdminDir.editar_elemento(11, %{name: "Regular Fit Padded Vest", category: "Tennis", stock: 20, brand: "Mizuno", price: 19.99})
Administrador.AdminDir.ver_catalogo()
Administrador.AdminDir.eliminar_elemento(11)
Administrador.AdminDir.ver_catalogo()
```

Cliente:
```bash
Cliente.ClienteDir.ver_catalogo()
Cliente.ClienteDir.anadir_cesta(1, 3, self())
Cliente.ClienteDir.anadir_cesta(2, 6, self())
Cliente.ClienteDir.anadir_cesta(1, 1, self())
Cliente.ClienteDir.ver_cesta(self())
2 Cliente.ClienteDir.ver_cesta(self())
Cliente.ClienteDir.eliminar_cesta(2, 6, self())
Cliente.ClienteDir.eliminar_cesta(1, 2, self())
Cliente.ClienteDir.ver_cesta(self())
Cliente.ClienteDir.comprar_cesta(self())
Cliente.ClienteDir.ver_cesta(self())
Administrador.AdminDir.ver_catalogo(1)
Cliente.ClienteDir.anadir_cesta(2, 6, self())
Cliente.ClienteDir.cancelar_cesta(self())

1 Cliente.ClienteDir.anadir_cesta(2, 4, self())
2 Cliente.ClienteDir.anadir_cesta(2, 3, self())
1 Cliente.ClienteDir.comprar_cesta(self())
2 Cliente.ClienteDir.comprar_cesta(self())
```
