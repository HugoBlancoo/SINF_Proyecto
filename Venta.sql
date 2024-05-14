DELIMITER $$

CREATE PROCEDURE Venta_Localidad_Espectaculo(IN p_Numero_Visa INT, IN p_Ubicacion VARCHAR(50), IN p_Grada VARCHAR(50), IN p_Titulo VARCHAR(50), IN p_Tipo VARCHAR(50), IN p_Productor VARCHAR(50))
BEGIN
    -- Comprueba si el cliente existe
    DECLARE v_ClienteExiste BOOLEAN;
    SELECT COUNT(*) INTO v_ClienteExiste FROM Cliente WHERE Numero_Visa = p_Numero_Visa;
    
    IF v_ClienteExiste = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe.';
    END IF;
    
    -- Comprueba si la localidad está disponible
    DECLARE v_LocalidadDisponible BOOLEAN;
    SELECT COUNT(*) INTO v_LocalidadDisponible FROM Localidades WHERE Ubicacion = p_Ubicacion AND Grada = p_Grada AND Estado = 'Libre';
    
    IF v_LocalidadDisponible = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La localidad no está disponible.';
    END IF;
    
    -- Comprueba si el espectáculo está programado para esa fecha y hora
    DECLARE v_EspectaculoProgramado BOOLEAN;
    SELECT COUNT(*) INTO v_EspectaculoProgramado FROM Realiza WHERE EspectaculoTitulo = p_Titulo AND EspectaculoTipo = p_Tipo AND EspectaculoProductor = p_Productor AND RecintoNombre = p_Ubicacion AND RecintoFecha = p_Grada;
    
    IF v_EspectaculoProgramado = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El espectáculo no está programado para esa fecha y hora.';
    END IF;
    
    -- Si todas las comprobaciones pasan, realiza la venta
    INSERT INTO Venta (ClienteNumero_Visa, LocalidadUbicacion, LocalidadGrada, P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada, P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, P_RealizaRecintoNombre, P_RealizaRecintoFecha, Tipo)
    VALUES (p_Numero_Visa, p_Ubicacion, p_Grada, 'Adulto', p_Ubicacion, p_Grada, p_Titulo, p_Tipo, p_Productor, p_Ubicacion, p_Grada, 'Pago');
    
    SELECT 'Venta realizada con éxito.' AS Mensaje;
END$$

DELIMITER ;
