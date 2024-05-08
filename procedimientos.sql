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
DELIMITER //
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
