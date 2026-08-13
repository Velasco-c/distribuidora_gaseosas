USE distribuidora;
/*
=================================================================
                        PRIMER TRIGGER
                        tr_actualizar_stock
=================================================================
*/

DELIMITER //
CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_pedido FOR EACH ROW
BEGIN 
	IF NEW.cantidad > 0 THEN
	UPDATE inventario
	SET stock_actual = stock_actual - NEW.cantidad
	WHERE producto_id = NEW.producto_id	;
	  END IF;
END //
DELIMITER ;

-- ---- PRUEBA DEL FLUJO COMPLETO ----
-- 1. Ver el estado inicial del inventario
SELECT * FROM inventario;
-- 2. Crear una nuevo detalle pedido
INSERT INTO detalle_pedido (pedido_id, producto_id, descripcion, precio_unitario,cantidad) VALUES 
(29, 10, 'Cola Tradicional 1.5 L', 13.50, 15);
-- 3. Verificar que el stock del producto disminuyó en 3 unidades
SELECT * FROM inventario;

/*
=================================================================
                        SEGUNDO TRIGGER
                        tr_auditar_cambio_precio
=================================================================
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
AFTER UPDATE ON productos FOR EACH ROW
BEGIN
    IF OLD.precio_unitario <> NEW.precio_unitario THEN
        INSERT INTO auditoria_precios ( producto_id, fecha_cambio,precio_anterior,precio_nuevo)
        VALUES ( NEW.producto_id, NOW(),OLD.precio_unitario,NEW.precio_unitario);
    END IF;
END //
DELIMITER ;

-- Consultar los datos
SELECT * FROM auditoria_precios;



	
