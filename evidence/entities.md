# Requerimientos y análisis de entidades

## 1. Descripción general

El sistema **Distribuidora** representa la gestión de clientes, productos, categorías, pedidos, sedes e inventario.

El modelo parte de una relación inicial que concentraba información de diferentes entidades. Mediante el proceso de normalización se separaron los datos hasta obtener un modelo en **Tercera Forma Normal (3FN)**.

El diseño utiliza claves primarias y foráneas para relacionar las entidades y reducir la duplicación de información.

---

## 2. Entidades del sistema

### Tabla: `clientes`

Almacena la información de los clientes.

| Campo                     | Tipo de dato | Restricciones | Descripción                      |
| ------------------------- | ------------ | ------------- | -------------------------------- |
| `id_cliente`              | INT          | PK            | Identificador único del cliente. |
| `nombre_completo_cliente` | VARCHAR(150) | NOT NULL      | Nombre completo del cliente.     |
| `identificacion_cliente`  | VARCHAR(30)  | UNIQUE        | Identificación del cliente.      |
| `direccion_cliente`       | VARCHAR(200) | NOT NULL      | Dirección del cliente.           |
| `telefono_cliente`        | VARCHAR(30)  | NOT NULL      | Teléfono del cliente.            |
| `correo_cliente`          | VARCHAR(150) | NOT NULL      | Correo electrónico del cliente.  |

### Tabla: `categorias`

Define las categorías de los productos.

| Campo                | Tipo de dato | Restricciones | Descripción                          |
| -------------------- | ------------ | ------------- | ------------------------------------ |
| `id_categoria`       | INT          | PK            | Identificador único de la categoría. |
| `categoria_producto` | VARCHAR(100) | NOT NULL      | Nombre de la categoría.              |

### Tabla: `productos`

Contiene la información propia de cada producto.

| Campo             | Tipo de dato | Restricciones | Descripción                         |
| ----------------- | ------------ | ------------- | ----------------------------------- |
| `id_producto`     | INT          | PK            | Identificador único del producto.   |
| `nombre_producto` | VARCHAR(150) | NOT NULL      | Nombre del producto.                |
| `id_categoria`    | INT          | FK            | Categoría del producto.             |
| `volumen_ml`      | INT          | NOT NULL      | Volumen del producto en mililitros. |

### Tabla: `encargados`

Registra los encargados de las sedes.

| Campo              | Tipo de dato | Restricciones | Descripción                        |
| ------------------ | ------------ | ------------- | ---------------------------------- |
| `id_encargado`     | INT          | PK            | Identificador único del encargado. |
| `nombre_encargado` | VARCHAR(150) | NOT NULL      | Nombre del encargado.              |

### Tabla: `sedes`

Representa las sedes de la distribuidora.

| Campo               | Tipo de dato | Restricciones | Descripción                     |
| ------------------- | ------------ | ------------- | ------------------------------- |
| `id_sede`           | INT          | PK            | Identificador único de la sede. |
| `nombre_sede`       | VARCHAR(100) | NOT NULL      | Nombre de la sede.              |
| `ubicacion_sede`    | VARCHAR(200) | NOT NULL      | Ubicación de la sede.           |
| `id_encargado`      | INT          | FK            | Encargado de la sede.           |
| `capacidad`         | INT          | NOT NULL      | Capacidad disponible.             |

### Tabla: `inventario`

Relaciona los productos con las sedes y controla las existencias.

| Campo          | Tipo de dato | Restricciones | Descripción                                     |
| -------------- | ------------ | ------------- | ----------------------------------------------- |
| `id_producto`  | INT          | PK, FK        | Producto almacenado.                            |
| `id_sede`      | INT          | PK, FK        | Sede donde se encuentra el producto.            |
| `stock_actual` | INT          | NOT NULL      | Existencia actual del producto en la sede.      |
| `stock_minimo` | INT          | NOT NULL      | Existencia mínima establecida para el producto. |

La clave primaria es compuesta:

```text
id_producto + id_sede
```

El stock se encuentra en esta tabla porque depende de la combinación del producto y la sede:

```text
id_producto + id_sede -> stock_actual, stock_minimo
```

### Tabla: `pedidos`

Representa la información general de cada pedido.

| Campo          | Tipo de dato | Restricciones | Descripción                     |
| -------------- | ------------ | ------------- | ------------------------------- |
| `id_pedido`    | INT          | PK            | Identificador único del pedido. |
| `fecha_pedido` | DATETIME     | NOT NULL      | Fecha y hora del pedido.        |
| `id_cliente`   | INT          | FK            | Cliente que realiza el pedido.  |
| `id_sede`      | INT          | FK            | Sede asociada al pedido.        |

El total del pedido puede obtenerse a partir de los detalles, por lo que `total_pedido_sin_iva` se considera un valor calculado y no es necesario almacenarlo directamente.

### Tabla: `detalle_pedido`

Representa los productos incluidos dentro de cada pedido.

| Campo             | Tipo de dato  | Restricciones | Descripción                                                    |
| ----------------- | ------------- | ------------- | -------------------------------------------------------------- |
| `id_pedido`       | INT           | PK, FK        | Pedido al que pertenece el detalle.                            |
| `id_producto`     | INT           | PK, FK        | Producto incluido en el pedido.                                |
| `descripcion `    | VARCHAR(255)  | NOT NULL      | Información o descripción relacionada con la línea del pedido. |
| `precio_unitario` | DECIMAL(10,2) | NOT NULL      | Precio aplicado al producto en el pedido.                      |
| `cantidad_pedida` | INT           | NOT NULL      | Cantidad solicitada.                                           |

La clave primaria es compuesta:

```text
id_pedido + id_producto
```

El subtotal de cada línea puede obtenerse mediante:

```text
precio_unitario * cantidad_pedida
```

por lo que `subtotal_linea` se considera un valor calculado.

---

## 3. Relaciones

| Tabla padre       | Tabla hija       | Cardinalidad | Clave foránea                |
| ----------------- | ---------------- | ------------ | ---------------------------- |
| `clientes`        | `pedidos`        | 1 : N        | `pedidos.id_cliente`         |
| `sedes`           | `pedidos`        | 1 : N        | `pedidos.id_sede`            |
| `pedidos`         | `detalle_pedido` | 1 : N        | `detalle_pedido.id_pedido`   |
| `productos`       | `detalle_pedido` | 1 : N        | `detalle_pedido.id_producto` |
| `categorias`      | `productos`      | 1 : N        | `productos.id_categoria`     |
| `productos`       | `inventario`     | 1 : N        | `inventario.id_producto`     |
| `sedes`           | `inventario`     | 1 : N        | `inventario.id_sede`         |
| `encargados`      | `sedes`          | 1 : N        | `sedes.id_encargado`         |

---

## 4. Diagrama del modelo normalizado

```mermaid
erDiagram

    CLIENTES ||--o{ PEDIDOS : realiza

    SEDES ||--o{ PEDIDOS : recibe

    PEDIDOS ||--|{ DETALLE_PEDIDO : contiene

    PRODUCTOS ||--o{ DETALLE_PEDIDO : incluye

    CATEGORIAS ||--o{ PRODUCTOS : clasifica

    PRODUCTOS ||--o{ INVENTARIO : registra

    SEDES ||--o{ INVENTARIO : almacena

    ENCARGADOS ||--o{ SEDES : administra

    CLIENTES {
        INT id_cliente PK
        VARCHAR nombre_completo_cliente
        VARCHAR identificacion_cliente UK
        VARCHAR direccion_cliente
        VARCHAR telefono_cliente
        VARCHAR correo_cliente
    }

    CATEGORIAS {
        INT id_categoria PK
        VARCHAR categoria_producto
    }

    PRODUCTOS {
        INT id_producto PK
        VARCHAR nombre_producto
        INT id_categoria FK
        INT volumen_ml
    }

    ENCARGADOS {
        INT id_encargado PK
        VARCHAR nombre_encargado
    }

    SEDES {
        INT id_sede PK
        VARCHAR nombre_sede
        VARCHAR ubicacion_sede
        INT id_encargado FK
        INT capacidad
    }

    INVENTARIO {
        INT id_producto PK, FK
        INT id_sede PK, FK
        INT stock_actual
        INT stock_minimo
    }

    PEDIDOS {
        INT id_pedido PK
        DATETIME fecha_pedido
        INT id_cliente FK
        INT id_sede FK
    }

    DETALLE_PEDIDO {
        INT id_pedido PK, FK
        INT id_producto PK, FK
        VARCHAR descripcion
        DECIMAL precio_unitario
        INT cantidad_pedida
    }
```

---

## 5. Normalización

### Primera Forma Normal (1FN)

La relación inicial contenía información de clientes, productos, pedidos, sedes e inventario dentro de una misma estructura.

Los atributos fueron identificados y organizados para poder separar posteriormente las entidades.

### Segunda Forma Normal (2FN)

Se eliminaron las dependencias parciales.

La información propia de cada entidad se separó de los datos que dependen de una combinación de claves.

En `detalle_pedido`, por ejemplo, los datos propios de una línea dependen de:

```text
id_pedido + id_producto
```

Por otro lado, el inventario depende de:

```text
id_producto + id_sede
```

### Tercera Forma Normal (3FN)

Se eliminaron las dependencias transitivas.

Por ejemplo:

```text
PRODUCTOS
    └── id_categoria

CATEGORIAS
    └── categoria_producto
```

De esta forma, el nombre de la categoría no necesita repetirse dentro de cada producto.

También se separó el inventario porque:

```text
id_producto + id_sede
    -> stock_actual
    -> stock_minimo
```

---

## 6. Distribución de los campos originales

La relación inicial `pedidos` contenía los siguientes campos:

| Campo original         | Ubicación después de la normalización  |
| ---------------------- | -------------------------------------- |
| `id_pedido`            | `pedidos`                              |
| `id_producto`          | `detalle_pedido`                       |
| `id_cliente`           | `pedidos`                              |
| `id_sede`              | `pedidos`                              |
| `detalles_pedido`      | `detalle_pedido`                       |
| `precio_unitario`      | `detalle_pedido`                       |
| `stock_actual`         | `inventario`                           |
| `stock_minimo`         | `inventario`                           |
| `cantidad_pedida`      | `detalle_pedido`                       |
| `subtotal_linea`       | Calculado en `detalle_pedido`          |
| `total_pedido_sin_iva` | Calculado a partir de `detalle_pedido` |

Esta distribución permite conservar la información original sin mantener todos los campos dentro de una sola tabla.

---

## 7. Valores calculados

Algunos valores de la relación original pueden obtenerse a partir de otros datos.

### Subtotal de la línea

```text
subtotal_linea =
precio_unitario * cantidad_pedida
```

El resultado depende de los datos de `detalle_pedido`.

### Total del pedido

```text
total_pedido_sin_iva =
SUM(subtotal_linea)
```

El total depende de todas las líneas asociadas al pedido.

Por esta razón, ambos valores pueden calcularse mediante consultas y no necesitan almacenarse físicamente.

---

## 8. Reglas principales

* Todos los identificadores utilizan `INT`.
* Las claves foráneas utilizan el mismo tipo de dato que sus claves primarias.
* `identificacion_cliente` debe ser única.
* Cada producto pertenece a una categoría.
* Cada pedido pertenece a un cliente y a una sede.
* Cada pedido puede contener múltiples productos mediante `detalle_pedido`.
* Un producto puede encontrarse en diferentes sedes mediante `inventario`.
* El inventario se identifica mediante `id_producto + id_sede`.
* `stock_actual` y `stock_minimo` pertenecen a `inventario`.
* `detalles_pedido`, `precio_unitario` y `cantidad_pedida` pertenecen a `detalle_pedido`.
* El precio unitario se conserva en `detalle_pedido` porque representa el precio aplicado en ese pedido.
* Los subtotales y totales pueden calcularse a partir de los datos almacenados.
* Los datos del cliente no se repiten dentro de cada pedido.
* Los datos descriptivos del producto no se repiten dentro de cada detalle.

---

## 9. Tipos de datos principales

### Identificadores

```sql
INT
```

Se utiliza para las claves primarias y foráneas.

No se utilizan identificadores como:

```text
CLI-001
PROD-101
PED-001
SED-01
```

como claves físicas de la base de datos.

### Valores monetarios

```sql
DECIMAL(10,2)
```

Se utiliza para `precio_unitario`.

### Valores numéricos

```sql
INT
```

Se utiliza para cantidades, volumen, capacidad y existencias.

### Texto

```sql
VARCHAR
```

Se utiliza para nombres, direcciones, correos, identificaciones y detalles.

### Fecha

```sql
DATETIME
```

Se utiliza para registrar la fecha y hora de los pedidos.

---

## 10. Resultado final

El modelo normalizado está compuesto por:

```text
clientes
categorias
productos
encargados
sedes
inventario
pedidos
detalle_pedido
```

Los campos de la relación original no se eliminan, sino que se distribuyen entre las entidades correspondientes según sus dependencias.

El resultado permite mantener separados los datos de clientes, productos, pedidos, detalles e inventario, reduciendo la redundancia y evitando dependencias parciales y transitivas.

El modelo cumple conceptualmente con la **Tercera Forma Normal (3FN)**.
