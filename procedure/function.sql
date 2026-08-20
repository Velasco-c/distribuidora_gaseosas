USE distribuidora;
/*
================================================================================
                        PRIMERA FUNCION
                        fn_calcular_total_con_iva(id_pedido)
================================================================================
*/
DROP FUNCTION IF EXISTS fn_calcular_total_con_iva;
DELIMITER //
CREATE FUNCTION fn_calcular_total_con_iva(id_ped INT, iva DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_iva_incluido DECIMAL(10,2);	
    SELECT SUM(dp.precio_unitario * dp.cantidad) * (1 + (iva / 100)) INTO total_iva_incluido
    FROM pedidos p 
    INNER JOIN detalle_pedido dp ON dp.pedido_id = p.id
    WHERE p.id = id_ped; 
    RETURN total_iva_incluido;
END//
DELIMITER ;
SELECT fn_calcular_total_con_iva(21,20);

	/*
	================================================================================
							    SEGUNDA FUNCION
					fn_validar_stock(id_producto, cantidad)
	================================================================================
	*/
DROP FUNCTION IF EXISTS fn_validar_stock;	
DELIMITER //
CREATE FUNCTION fn_validar_stock(id_prod INT, cantidad INT)
RETURNS VARCHAR(150)
DETERMINISTIC
	BEGIN
		DECLARE stock INT;
        SELECT stock_actual INTO stock FROM inventario i 
		WHERE i.producto_id = id_prod;
		IF stock IS NULL THEN
			RETURN 'El producto no existe en inventario';
		ELSEIF stock >= cantidad THEN
			RETURN 'Stock disponible';
		ELSE
			RETURN CONCAT('Stock insuficiente. Disponible: ', stock);
		END IF; 
	END//
DELIMITER ; 
    
SELECT fn_validar_stock(1, 500);



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