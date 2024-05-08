DROP PROCEDURE IF EXISTS restringir_usuarios
DROP PROCEDURE IF EXISTS restringir_aforo
DROP PROCEDURE IF EXISTS limitar_usuarios
DROP PROCEDURE IF EXISTS vender_entrada
DROP PROCEDURE IF EXISTS anular_reserva

-- ver funciones creadas
SHOW PROCEDURE STATUS WHERE Db = 'Taquilla_virtual';

-- [2] No comprar entradas para tipos de usuarios no permitidos
DELIMITER //
CREATE PROCEDURE restringir_usuarios()
BEGIN
    SELECT 
END //
DELIMITER ;

CALL restringir_usuarios();

-- [4] Que no superen los aforos establecidos
DELIMITER restringir_aforo()//
CREATE PROCEDURE 
BEGIN
    SELECT
END //
DELIMITER ;

CALL 

-- [5] Limitar el numero de entradas/usuarios para un evento
DELIMITER //
CREATE PROCEDURE limitar_usuarios()
BEGIN
    SELECT
END //
DELIMITER ;

CALL limitar_usuarios()

-- [6] Solo vender entradas de eventos abiertos
DELIMITER //
CREATE PROCEDURE vender_entrada()   
BEGIN
    SELECT
END //
DELIMITER ;

CALL vender_entrada()

-- [8] No anular una reserva no hecha por mi
DELIMITER //
CREATE PROCEDURE anular_reserva()
BEGIN
    SELECT
END //
DELIMITER ;

CALL 

DELIMITER //

CREATE PROCEDURE VenderLocalidad(IN p_ClienteNumero_Visa INT, IN p_LocalidadUbicacion VARCHAR(50))
BEGIN
    DECLARE v_NumMax INT;
    DECLARE v_CantidadDisponible INT;
    DECLARE v_EstadoRecinto ENUM('Finalizado', 'Abierto', 'Cerrado');

    SELECT NumMax INTO v_NumMax FROM Recinto WHERE Nombre = 'NombreDelRecinto' AND Fecha = 'FechaDelRecinto';
    SELECT Estado INTO v_EstadoRecinto FROM Recinto WHERE Nombre = 'NombreDelRecinto' AND Fecha = 'FechaDelRecinto';

    IF v_EstadoRecinto = 'Abierto' THEN
        SELECT COUNT(*) INTO v_CantidadDisponible FROM Localidades WHERE Ubicacion = p_LocalidadUbicacion AND Estado = 'Libre';

        IF v_CantidadDisponible > 0 THEN
            -- CODIGO VENTA
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay localidades disponibles para la venta.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El recinto no está abierto para ventas.';
    END IF;
END//

DELIMITER ;

