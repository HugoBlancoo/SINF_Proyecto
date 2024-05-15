DROP PROCEDURE IF EXISTS restringir_usuarios;
DROP PROCEDURE IF EXISTS restringir_aforo;
DROP PROCEDURE IF EXISTS limitar_usuarios;
DROP PROCEDURE IF EXISTS vender_entrada;
DROP PROCEDURE IF EXISTS anular_reserva;
DROP PROCEDURE IF EXISTS comprar_localidad;

-- ver funciones creadas
SHOW PROCEDURE STATUS WHERE Db = 'Taquilla_virtual';

-- [2] No comprar entradas para tipos de usuarios no permitidos
DELIMITER //
CREATE PROCEDURE restringir_usuarios()
BEGIN
    -- Declaración de variables para almacenar los valores recuperados de las consultas
    DECLARE done INT DEFAULT FALSE;
    DECLARE espectaculo_genero VARCHAR(50);
    DECLARE usuario_tipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado');
    -- Declaración de un cursor para iterar sobre las ofertas y usuarios
    DECLARE cur CURSOR FOR 
        SELECT Genero, OfertaUsuarioTipo, Numero_Visa, Titulo, Tipo, Productor
        FROM Espectaculo e
        JOIN Pertenecen p ON e.Titulo = p.R_EspectaculoTitulo AND e.Tipo = p.R_EspectaculoTipo AND e.Productor = p.R_EspectaculoProductor
        JOIN Cliente c ON p.OfertaUsuarioTipo = c.tipo;
    -- Declaración del manejador de eventos para el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO espectaculo_genero, usuario_tipo, @numero_visa, @titulo_espectaculo, @tipo_espectaculo, @productor_espectaculo;
        -- Si no hay más filas, salir del bucle
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Verificación de las restricciones de género
        IF (espectaculo_genero = 'No_infantil' AND usuario_tipo = 'Infantil') OR
           (espectaculo_genero = 'No_jubilado' AND usuario_tipo = 'Jubilado') THEN
            -- Si se viola una restricción, lanzar un error y mostrar la información relevante
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = CONCAT(  'Error: Usuario con tipo ', usuario_tipo,
                                        ' no permitido para el espectáculo ', @titulo_espectaculo,
                                        ' de tipo ', @tipo_espectaculo,
                                        ' y productor ', @productor_espectaculo,'.');
            -- Imprimir la tupla del cliente y el espectáculo que no cumple con las restricciones
            SELECT @numero_visa AS Numero_Visa, @titulo_espectaculo AS Titulo_Espectaculo, @tipo_espectaculo AS Tipo_Espectaculo, @productor_espectaculo AS Productor_Espectaculo;
            -- Aquí se elimina la tupla que no cumple con las restricciones
            DELETE FROM Pertenecen WHERE Numero_Visa = @numero_visa AND R_EspectaculoTitulo = @titulo_espectaculo AND R_EspectaculoTipo = @tipo_espectaculo AND R_EspectaculoProductor = @productor_espectaculo;
        END IF;
    END LOOP;

    CLOSE cur;
END; //
DELIMITER ;

CALL restringir_usuarios();

-- [4] Que no superen los aforos establecidos
DELIMITER //

CREATE PROCEDURE restringir_aforo()
BEGIN
    DECLARE recinto_nombre VARCHAR(50);
    DECLARE recinto_fecha TIMESTAMP;
    DECLARE num_max_localidades INT;
    DECLARE num_localidades_actuales INT;
    DECLARE num_localidades_a_eliminar INT;
    
    -- Cursor para obtener todos los recintos
    DECLARE recinto_cursor CURSOR FOR
        SELECT Nombre, Fecha, NumMax
        FROM Recinto;
    
    -- Variables para manejar el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrir el cursor
    OPEN recinto_cursor;

    -- Iniciar bucle para recorrer todos los recintos
    recinto_loop: LOOP
        FETCH recinto_cursor INTO recinto_nombre, recinto_fecha, num_max_localidades;
        
        -- Verificar si se han recuperado todos los registros
        IF done THEN
            LEAVE recinto_loop;
        END IF;

        -- Obtener el número actual de localidades para el recinto
        SELECT COUNT(*) INTO num_localidades_actuales
        FROM Pertenecen
        WHERE R_RecintoNombre = recinto_nombre
            AND R_RecintoFecha = recinto_fecha;

        -- Calcular cuántas localidades eliminar para cumplir con el máximo
        IF num_localidades_actuales > num_max_localidades THEN
            SET num_localidades_a_eliminar = num_localidades_actuales - num_max_localidades;
            
            -- Eliminar las localidades adicionales
            DELETE FROM Pertenecen
            WHERE R_RecintoNombre = recinto_nombre
                AND R_RecintoFecha = recinto_fecha
            ORDER BY R_RecintoFecha DESC -- Eliminar las más recientes primero
            LIMIT num_localidades_a_eliminar;
        END IF;
    END LOOP;

    -- Cerrar el cursor
    CLOSE recinto_cursor;
    
    SELECT 'Restricción de aforo aplicada exitosamente.';
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

CREATE PROCEDURE eliminar_ofertas_recintos_cerrados_finalizados()
BEGIN
    -- Eliminar ofertas para recintos cerrados o finalizados
    DELETE FROM Pertenecen
    WHERE (R_RecintoFecha < NOW() AND Realiza.Estado = 'Finalizado')
        OR (Realiza.Estado = 'Cerrado');
    
    SELECT 'Ofertas eliminadas para recintos cerrados o finalizados.';
END //

DELIMITER ;

CALL eliminar_ofertas_recintos_cerrados_finalizados()

-- [8] No anular una reserva no hecha por mi
DELIMITER //
CREATE PROCEDURE anular_reserva()
BEGIN
    SELECT
END //
DELIMITER ;

CALL 

-- Vender localidad
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

-- Comprar una localidad

DELIMITER //

CREATE PROCEDURE comprar_localidad(
    IN p_numero_visa INT,
    IN p_localidad_ubicacion VARCHAR(50),
    IN p_localidad_grada VARCHAR(50),
    IN p_tipo_usuario ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado'),
    IN p_espectaculo_titulo VARCHAR(50),
    IN p_espectaculo_tipo VARCHAR(50),
    IN p_espectaculo_productor VARCHAR(50),
    IN p_recinto_nombre VARCHAR(50),
    IN p_recinto_fecha TIMESTAMP,
    IN p_tipo_operacion ENUM('Reserva', 'Pago')
)
BEGIN
    DECLARE recinto_estado ENUM('Finalizado', 'Abierto', 'Cerrado');
    DECLARE permite_existe BOOLEAN;
    DECLARE localidad_vendida BOOLEAN;

    -- Comprobar si el cliente existe
    IF NOT EXISTS (SELECT * FROM Cliente WHERE Numero_Visa = p_numero_visa) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;

    -- Comprobar si el recinto está abierto en la fecha especificada
    SELECT Estado INTO recinto_estado
    FROM Recinto
    WHERE Nombre = p_recinto_nombre AND Fecha = p_recinto_fecha;

    IF recinto_estado != 'Abierto' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El recinto no está abierto en la fecha especificada';
    END IF;

    -- Verificar si el tipo de usuario está permitido para el espectáculo
    SELECT EXISTS (
        SELECT 1
        FROM Permite
        WHERE UsuarioTipo = p_tipo_usuario AND EspectaculoTitulo = p_espectaculo_titulo
    ) INTO permite_existe;

    IF NOT permite_existe THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de usuario no está permitido para este espectáculo';
    END IF;

    -- Verificar si la localidad en la grada y el recinto ya está vendida
    SELECT EXISTS (
        SELECT 1
        FROM Venta
        WHERE LocalidadUbicacion = p_localidad_ubicacion AND LocalidadGrada = p_localidad_grada
    ) INTO localidad_vendida;

    IF localidad_vendida THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La localidad ya ha sido vendida';
    END IF;

    -- Insertar la localidad en la tabla de ventas
    INSERT INTO Venta 
        (ClienteNumero_Visa, LocalidadUbicacion, LocalidadGrada, 
        P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada, 
        P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, 
        P_RealizaRecintoNombre, P_RealizaRecintoFecha, Tipo)
    VALUES (p_numero_visa, p_localidad_ubicacion, p_localidad_grada, p_tipo_usuario, 
        p_localidad_ubicacion, p_localidad_grada, p_espectaculo_titulo, p_espectaculo_tipo, p_espectaculo_productor, p_recinto_nombre, p_recinto_fecha, p_tipo_operacion);

    SELECT 'Localidad comprada y puesta en venta exitosamente' AS Resultado;
END //

DELIMITER ;


-- Anular Reserva

DELIMITER //
CREATE PROCEDURE AnularReserva(
    IN p_Numero_Visa INT,
    IN p_LocalidadUbicacion VARCHAR(50),
    IN p_LocalidadGrada VARCHAR(50),
    IN p_EspectaculoTitulo VARCHAR(50),
    IN p_EspectaculoTipo VARCHAR(50),
    IN p_EspectaculoProductor VARCHAR(50),
    IN p_RecintoNombre VARCHAR(50),
    IN p_RecintoFecha TIMESTAMP
)
BEGIN
    DECLARE total_reservas INT;

    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO total_reservas FROM Cliente WHERE Numero_Visa = p_Numero_Visa;
    IF total_reservas = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente especificado no existe';
    END IF;

    -- Verificar si el cliente tiene alguna reserva
    SELECT COUNT(*) INTO total_reservas FROM Venta
    WHERE ClienteNumero_Visa = p_Numero_Visa AND
          LocalidadUbicacion = p_LocalidadUbicacion AND
          LocalidadGrada = p_LocalidadGrada AND
          P_RealizaEspectaculoTitulo = p_EspectaculoTitulo AND
          P_RealizaEspectaculoTipo = p_EspectaculoTipo AND
          P_RealizaEspectaculoProductor = p_EspectaculoProductor AND
          P_RealizaRecintoNombre = p_RecintoNombre AND
          P_RealizaRecintoFecha = p_RecintoFecha AND
          Tipo = 'Reserva';

    IF total_reservas = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no tiene ninguna reserva para esta localidad y espectáculo';
    END IF;

    -- Anular la reserva
    DELETE FROM Venta
    WHERE ClienteNumero_Visa = p_Numero_Visa AND
          LocalidadUbicacion = p_LocalidadUbicacion AND
          LocalidadGrada = p_LocalidadGrada AND
          P_RealizaEspectaculoTitulo = p_EspectaculoTitulo AND
          P_RealizaEspectaculoTipo = p_EspectaculoTipo AND
          P_RealizaEspectaculoProductor = p_EspectaculoProductor AND
          P_RealizaRecintoNombre = p_RecintoNombre AND
          P_RealizaRecintoFecha = p_RecintoFecha AND
          Tipo = 'Reserva';

    SELECT 'Reserva anulada exitosamente' AS Message;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE TotalRecaudadoPorEspectaculo()
BEGIN
    SELECT
        V.P_RealizaEspectaculoTitulo AS Espectaculo_Titulo,
        V.P_RealizaEspectaculoTipo AS Espectaculo_Tipo,
        V.P_RealizaEspectaculoProductor AS Espectaculo_Productor,
        SUM(
            CASE
                WHEN V.Tipo = 'Pago' THEN P.Precio
                ELSE 0
            END
        ) AS Total_Recaudado
    FROM
        Venta V
        JOIN Pertenecen P ON V.P_OfertaUsuarioTipo = P.OfertaUsuarioTipo
            AND V.P_OfertaLocalidadUbicacion = P.OfertaLocalidadUbicacion
            AND V.P_OferataLocalidadGrada = P.OfertaLocalidadGrada
            AND V.P_RealizaEspectaculoTitulo = P.R_EspectaculoTitulo
            AND V.P_RealizaEspectaculoTipo = P.R_EspectaculoTipo
            AND V.P_RealizaEspectaculoProductor = P.R_EspectaculoProductor
            AND V.P_RealizaRecintoNombre = P.R_RecintoNombre
            AND V.P_RealizaRecintoFecha = P.R_RecintoFecha
    GROUP BY
        V.P_RealizaEspectaculoTitulo,
        V.P_RealizaEspectaculoTipo,
        V.P_RealizaEspectaculoProductor;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE CambiarEstadoEventos()
BEGIN
    -- Cambiar el estado de los eventos cerrados a abiertos en la tabla Recinto
    UPDATE Recinto
    SET Estado = 'Abierto'
    WHERE Estado = 'Cerrado';

    -- Cambiar el estado de los eventos cerrados a abiertos en la tabla Realiza
    UPDATE Realiza
    SET RecintoFecha = (
        SELECT Fecha
        FROM Recinto
        WHERE Estado = 'Abierto'
        LIMIT 1
    )
    WHERE RecintoFecha IN (
        SELECT Fecha
        FROM Recinto
        WHERE Estado = 'Cerrado'
    );

    -- Cambiar el estado de los eventos cerrados a abiertos en la tabla Pertenecen
    UPDATE Pertenecen
    SET R_RecintoFecha = (
        SELECT Fecha
        FROM Recinto
        WHERE Estado = 'Abierto'
        LIMIT 1
    )
    WHERE R_RecintoFecha IN (
        SELECT Fecha
        FROM Recinto
        WHERE Estado = 'Cerrado'
    );
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS `CambiarEstadoEventos`;

