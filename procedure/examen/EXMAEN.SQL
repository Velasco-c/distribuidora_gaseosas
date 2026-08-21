/*
========================================================
                    EXAMEN
=======================================================
*/

/*
Crear una vista llamada vista_resumen_sedes que:
Muestre por cada sede:
Nombre de la sede
Cantidad total de pedidos despachados
Valor total vendido (sin IVA)
Promedio de valor por pedido
La vista debe usar JOIN entre pedidos y sedes, y agrupar correctamente los resultados.
*/

DROP VIEW IF EXISTS vista_resumen_sedes;

CREATE VIEW vista_resumen_sedes AS
SELECT
    s.nombre AS sede,
    COUNT(DISTINCT p.id) AS total_pedidos,
    COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) AS total_ventas,
    COALESCE(
        SUM(dp.cantidad * dp.precio_unitario) / NULLIF(COUNT(DISTINCT p.id), 0),
        0
    ) AS promedio_valor_pedido
FROM sedes s
LEFT JOIN pedidos p
    ON s.id = p.sede_id
LEFT JOIN detalle_pedido dp
    ON p.id = dp.pedido_id
GROUP BY
    s.id,
    s.nombre;
    
SELECT * FROM  vista_resumen_sedes;


/*
=======================================================================
														EXAMEN
=======================================================================
*/


/*
==========================================================================
    Crear una función MySQL llamada calcular_promedio_pedidos_cliente que:
    Reciba como parámetro el ID de un cliente.
    Retorne el promedio del total (sin IVA) de todos los pedidos realizados por ese cliente.
    Si el cliente no tiene pedidos, retorne 0.
==========================================================================
*/


DROP FUNCTION IF EXISTS fn_calcular_promedio_pedidos;

DELIMITER //

CREATE FUNCTION fn_calcular_promedio_pedidos(id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT COALESCE(AVG(total_pedido), 0)
    INTO promedio
    FROM (
        SELECT
            p.id,
            SUM(dp.precio_unitario * dp.cantidad) AS total_pedido
        FROM pedidos p
        INNER JOIN detalle_pedido dp
            ON dp.pedido_id = p.id
        WHERE p.cliente_id = id_cliente
        GROUP BY p.id
    ) AS pedidos_cliente;

    RETURN promedio;
END//

DELIMITER ;

SELECT fn_calcular_promedio_pedidos(1);

/*
======================================================================
                        EXAMEN
======================================================================
*/

/*
Realizar una consulta con subconsulta que:
Muestre el nombre del producto, categoría y stock
Solo incluya los productos cuyo precio sea mayor al promedio general de precios de todos los productos.
Crear un trigger llamado auditar_cambio_precio que:
Se ejecute después de un UPDATE en la tabla de productos.
*/

USE distribuidora;

SELECT p.nombre as productos , c.nombre AS categoria,i.stock_actual
FROM productos p
INNER JOIN inventario i ON i.producto_id = p.id
INNER JOIN categorias c ON c.id = p.categoria_id
GROUP BY p.nombre, c.nombre ,i.stock_actual
HAVING  p.precio_unitario > AVG(p.precio_unitario);

/*
============================================================
                        examen
============================================================
*/

CREATE TABLE IF NOT EXISTS auditoria_precios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    fecha_cambio DATETIME NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL
);

DELIMITER //
CREATE TRIGGER tr_auditar_cambio_precio
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
    IF OLD.precio_unitario <> NEW.precio_unitario THEN
        INSERT INTO auditoria_precios (producto_id, fecha_cambio, precio_anterior, precio_nuevo)
        VALUES (NEW.id,NOW(),OLD.precio_unitario,NEW.precio_unitario);
    END IF;
END //
DELIMITER ;
-- Consultar los datos
SELECT * FROM auditoria_precios;


UPDATE productos
SET precio_unitario = 15.00
WHERE id = 10;

UPDATE productos
SET precio_unitario = 16.50
WHERE id = 10;

SELECT *
FROM auditoria_precios
WHERE producto_id = 10
ORDER BY fecha_cambio DESC;