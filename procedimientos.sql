-- ver funciones creadas
SHOW PROCEDURE STATUS WHERE Db = 'Taquilla_virtual';

-- [2] No comprar entradas para tipos de usuarios no permitidos
DELIMITER //
CREATE PROCEDURE restringir_usuarios()
BEGIN
    SELECT 
END //
DELIMITER ;

CALL 

-- [4] Que no superen los aforos establecidos
-- [5] Limitar el numero de entradas/usuarios para un evento
-- [6] Solo vender entradas de eventos abiertos
-- [8] No anular una reserva no hecha por mi
