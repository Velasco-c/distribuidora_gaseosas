# Distribuidora de Gaseosas del Valle S.A.

Sistema de gestión de base de datos para una distribuidora de bebidas, diseñado para administrar clientes, productos, categorías, sedes, inventario y pedidos, incorporando consultas SQL, funciones y triggers para automatizar operaciones y facilitar el análisis de la información.

## Descripción

La base de datos `distribuidora` está diseñada bajo un modelo relacional, utilizando **MySQL** e **InnoDB**.

El diseño separa la información en entidades independientes y establece relaciones mediante claves primarias y foráneas. Esto permite mantener la integridad referencial, evitar la duplicación innecesaria de información y facilitar la consulta de los datos.

El proyecto también incorpora:

* Consultas SQL con `JOIN`, `GROUP BY`, `ORDER BY`, `BETWEEN`, `LIKE`, `IN` y subconsultas.
* Funciones almacenadas para cálculos y validaciones.
* Triggers para automatizar modificaciones del inventario y registrar cambios de precios.
* Restricciones `NOT NULL`, `UNIQUE` y `CHECK`.
* Tabla de auditoría para cambios de precios.

## Estructura del proyecto

```text
DISTRIBUIDORA_GASEOSAS/
│
├── DLL/
│   ├── schema.sql
│   └── view.sql
│
├── DML/
│   └── insert.sql
│
├── DQL/
│   └── consultation.sql
│
├── procedure/
│   ├── function.sql
│   └── triggers.sql
│
├── evidence/
│   ├── ER/
│   │   └── distribuidora_normalizada_3FN.xlsx
│   │
│   └── images/
│       └── entities.png
│
├── entities.md
└── README.md
```

### Organización

| Directorio    | Propósito                                                  |
| ------------- | ---------------------------------------------------------- |
| `DLL/`        | Definición de la estructura de la base de datos y vistas.  |
| `DML/`        | Inserción y carga de datos.                                |
| `DQL/`        | Consultas para obtener y analizar información.             |
| `procedure/`  | Funciones y triggers almacenados.                          |
| `evidence/`   | Evidencias y documentación del diseño de la base de datos. |
| `entities.md` | Descripción de las entidades del sistema.                  |
| `README.md`   | Documentación general del proyecto.                        |

## Modelo de datos

La base de datos está compuesta por las siguientes entidades principales:

### `clientes`

Almacena la información de los clientes de la distribuidora.

Entre sus datos se encuentran:

* Nombre completo.
* Identificación.
* Dirección.
* Teléfono.
* Correo electrónico.

La identificación se establece como `UNIQUE` para evitar registros duplicados.

### `categorias`

Contiene las categorías utilizadas para clasificar los productos.

### `productos`

Representa los productos comercializados por la distribuidora.

Cada producto contiene:

* Nombre.
* Categoría.
* Volumen en mililitros.
* Precio unitario.

La relación con `categorias` permite clasificar cada producto sin repetir la información de la categoría en cada registro.

Además, se utilizan restricciones `CHECK` para garantizar que el volumen sea mayor que cero y que el precio no sea negativo.

### `encargados`

Almacena los responsables de las diferentes sedes.

### `sedes`

Representa los establecimientos o puntos de operación de la distribuidora.

Cada sede posee:

* Nombre.
* Ubicación.
* Encargado.
* Capacidad.

La relación con `encargados` permite asociar un responsable a cada sede.

### `inventario`

Relaciona las sedes con los productos y permite controlar:

* Stock actual.
* Stock mínimo.

Esta entidad permite utilizar la información de inventario para detectar productos con existencias insuficientes y automatizar la actualización del stock mediante triggers.

### `pedidos`

Registra los pedidos realizados por los clientes.

Cada pedido mantiene relación con:

* Un cliente.
* Una sede.
* Una fecha de realización.

La fecha utiliza `CURRENT_TIMESTAMP` como valor predeterminado.

### `detalle_pedido`

Representa los productos incluidos dentro de cada pedido.

Almacena:

* Pedido.
* Producto.
* Descripción.
* Precio unitario.
* Cantidad.

Utiliza una clave primaria compuesta por:

```sql
PRIMARY KEY (pedido_id, producto_id)
```

Esto evita que un mismo producto sea registrado dos veces dentro del mismo pedido.

## Relaciones principales

El modelo está compuesto por entidades independientes que se relacionan de acuerdo con las operaciones de la distribuidora. No existe una entidad que actúe como origen jerárquico de todas las demás.

Las principales relaciones son:

* **Categorías → Productos:** cada producto pertenece a una categoría.
* **Encargados → Sedes:** cada sede tiene un encargado responsable.
* **Sedes ↔ Productos:** la relación se utiliza para gestionar el inventario disponible en cada sede.
* **Clientes → Pedidos:** un cliente puede realizar múltiples pedidos.
* **Sedes → Pedidos:** cada pedido se registra en una sede determinada.
* **Pedidos → Detalle de pedido:** un pedido puede contener uno o varios productos.
* **Productos → Detalle de pedido:** un producto puede aparecer en diferentes pedidos.

Las relaciones se implementan mediante claves foráneas, permitiendo mantener la integridad referencial y garantizar que los registros relacionados existan dentro del modelo.

En conjunto, el modelo separa tres áreas principales del sistema:

```text
CATÁLOGO
Categorías ── Productos

OPERACIÓN
Encargados ── Sedes ── Inventario ── Productos

VENTAS
Clientes ── Pedidos ── Detalle de pedido ── Productos
                     │
                     └── Sedes
```

Esta representación describe las relaciones funcionales del sistema sin establecer una jerarquía artificial entre las entidades.

## Justificación del diseño

El diseño utiliza una separación clara de responsabilidades entre las entidades.

En lugar de almacenar toda la información de un pedido, cliente, producto y sede en una única tabla, cada concepto se mantiene de forma independiente y se relaciona mediante identificadores.

Esto permite:

* Reducir redundancia.
* Mantener consistencia en los datos.
* Facilitar modificaciones.
* Evitar duplicación de información.
* Simplificar las consultas mediante relaciones.
* Mantener integridad referencial mediante claves foráneas.

El uso de restricciones también permite aplicar reglas directamente desde la base de datos.

Por ejemplo:

```sql
CHECK (precio_unitario >= 0)
CHECK (cantidad > 0)
CHECK (stock_actual >= 0)
```

De esta manera, se evita almacenar valores que no tengan sentido dentro del contexto del sistema.

## Consultas SQL

El archivo `consultation.sql` contiene consultas orientadas a la operación y análisis de la información.

Entre ellas se encuentran:

1. **Productos con stock inferior al mínimo**

   Permite identificar productos que requieren reposición.

2. **Pedidos entre dos fechas**

   Utiliza `BETWEEN` para consultar pedidos dentro de un período determinado.

3. **Productos más vendidos**

   Utiliza `JOIN`, `GROUP BY`, `SUM` y `ORDER BY` para determinar los productos con mayor cantidad de unidades vendidas.

4. **Cantidad de pedidos por cliente**

   Permite conocer el número de pedidos realizados por cada cliente.

5. **Búsqueda parcial de clientes**

   Utiliza `LIKE` para localizar clientes mediante coincidencias parciales de nombre.

6. **Consulta mediante `IN`**

   Permite filtrar productos utilizando una subconsulta.

7. **Cliente con mayor número de pedidos**

   Utiliza una subconsulta para identificar al cliente con mayor cantidad de pedidos.

8. **Ventas agrupadas por sede**

   Permite conocer la cantidad de pedidos y el total de ventas generado por cada sede.

Estas consultas demuestran el uso de diferentes mecanismos del lenguaje SQL para obtener información operativa y generar indicadores básicos del negocio.

## Funciones almacenadas

El proyecto incorpora dos funciones.

### `fn_calcular_total_con_iva`

Calcula el total de un pedido aplicando un porcentaje de IVA recibido como parámetro.

```text
fn_calcular_total_con_iva(id_pedido, iva)
```

El cálculo se realiza a partir de:

```text
precio_unitario × cantidad
```

y posteriormente se aplica el porcentaje de impuesto indicado.

Su objetivo es centralizar el cálculo del total de un pedido y evitar repetir la misma lógica en diferentes consultas.

### `fn_validar_stock`

Comprueba si existe suficiente inventario para una cantidad determinada de producto.

```text
fn_validar_stock(id_producto, cantidad)
```

La función puede devolver diferentes estados:

* Producto inexistente en inventario.
* Stock disponible.
* Stock insuficiente indicando la cantidad disponible.

Esto permite realizar una validación sencilla antes de ejecutar operaciones que involucren inventario.

## Triggers

El proyecto utiliza triggers para automatizar determinadas operaciones.

### `tr_actualizar_stock`

Se ejecuta después de insertar un registro en `detalle_pedido`.

Su objetivo es disminuir automáticamente el `stock_actual` del producto correspondiente según la cantidad agregada al pedido.

Conceptualmente:

```text
Nuevo detalle de pedido
        ↓
Trigger
        ↓
Descuento automático del inventario
```

Esto evita depender de una actualización manual del inventario después de registrar cada detalle de pedido.

### `tr_auditar_cambio_precio`

Su propósito es registrar modificaciones realizadas sobre el precio de los productos.

Cuando se modifica el precio unitario de un producto, se registra en `auditoria_precios`:

* Producto afectado.
* Fecha del cambio.
* Precio anterior.
* Precio nuevo.

Esto proporciona un mecanismo básico de auditoría histórica.

## Auditoría

La tabla:

```sql
auditoria_precios
```

permite conservar un historial de cambios realizados sobre los precios.

Su estructura mantiene la información necesaria para conocer:

```text
Producto → Fecha → Precio anterior → Precio nuevo
```

De esta manera, la base de datos no solo almacena el estado actual del producto, sino que también puede conservar evidencia de modificaciones anteriores.

## Vistas

El directorio `DLL/` también contiene las vistas del sistema.

Las vistas están orientadas a presentar información derivada de las tablas principales sin tener que repetir consultas complejas cada vez que se necesiten determinados indicadores.

Entre los reportes contemplados se encuentran:

* Resumen de pedidos y ventas por sede.
* Productos con bajo stock.
* Clientes activos.

Las vistas proporcionan una capa de consulta reutilizable para facilitar el acceso a información frecuente.

## Integridad de los datos

El diseño utiliza diferentes mecanismos de integridad:

### Claves primarias

Identifican de manera única cada registro.

### Claves foráneas

Establecen relaciones válidas entre las entidades y evitan referencias a registros inexistentes.

### `NOT NULL`

Garantiza que los campos obligatorios contengan información.

### `UNIQUE`

Evita duplicados en campos que deben ser únicos, como la identificación de los clientes.

### `CHECK`

Permite validar reglas básicas del dominio, como:

```sql
volumen_ml > 0
precio_unitario >= 0
cantidad > 0
stock_actual >= 0
stock_minimo >= 0
capacidad > 0
```

## Tecnologías

* **MySQL**
* **SQL**
* **InnoDB**
* Funciones almacenadas
* Triggers
* Vistas
* Consultas relacionales

## Objetivo del proyecto

El objetivo es implementar una base de datos relacional funcional para una distribuidora de bebidas, aplicando conceptos de modelado, integridad de datos y programación SQL.

El proyecto integra en una misma solución:

* Diseño de entidades y relaciones.
* Gestión de clientes y productos.
* Control de inventario.
* Registro de pedidos.
* Consultas analíticas.
* Funciones almacenadas.
* Automatización mediante triggers.
* Auditoría de modificaciones.
* Vistas para generación de información resumida.

El resultado es una estructura de base de datos organizada y orientada a representar las operaciones principales de una distribuidora.
