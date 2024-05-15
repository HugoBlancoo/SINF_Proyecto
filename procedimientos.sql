DROP PROCEDURE IF EXISTS restringir_usuarios;
DROP PROCEDURE IF EXISTS restringir_aforo;
DROP PROCEDURE IF EXISTS limitar_usuarios;
DROP PROCEDURE IF EXISTS vender_entrada;
DROP PROCEDURE IF EXISTS anular_reserva;
DROP PROCEDURE IF EXISTS comprar_localidad;

-- ver funciones creadas
SHOW PROCEDURE STATUS WHERE Db = 'Taquilla_virtual';

-- Comprar Localidad;
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
        WHERE LocalidadUbicacion = p_localidad_ubicacion AND LocalidadGrada = p_localidad_grada AND P_RealizaRecintoNombre = p_recinto_nombre
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


-- Espectaculos por Recinto y Fecha
DROP PROCEDURE IF EXISTS VerEspectaculosEnRecinto;

DELIMITER //

CREATE PROCEDURE VerEspectaculosEnRecinto(
    IN p_recintoNombre VARCHAR(50),
    IN p_fecha TIMESTAMP
)
BEGIN
    SELECT 
        EspectaculoTitulo AS Título,
        EspectaculoTipo AS Tipo,
        EspectaculoProductor AS Productor
    FROM 
        Realiza
    WHERE 
        RecintoNombre = p_recintoNombre AND RecintoFecha = p_fecha;
END //

DELIMITER ;

-- Que espectaculos hay disponibles para un tipo de usuario
DROP PROCEDURE IF EXISTS VerEspectaculosPorTipoUsuario;

DELIMITER //

CREATE PROCEDURE VerEspectaculosPorTipoUsuario(
    IN p_usuarioTipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado')
)
BEGIN
    SELECT 
        EspectaculoTitulo AS Título,
        EspectaculoTipo AS Tipo,
        EspectaculoProductor AS Productor
    FROM 
        Permite
    WHERE 
        UsuarioTipo = p_usuarioTipo;
END //

DELIMITER ;

-- Entradas compradas por un cliente
DROP PROCEDURE IF EXISTS VerEntradasCompradasPorCliente;
DELIMITER //

CREATE PROCEDURE VerEntradasCompradasPorCliente(
    IN p_numeroVisa INT
)
BEGIN
    SELECT 
        LocalidadUbicacion AS Localidad,
        LocalidadGrada AS Grada,
        P_OfertaUsuarioTipo AS Usuario,
        P_RealizaRecintoFecha AS Fecha,
        P_RealizaRecintoNombre AS Recinto,
        P_RealizaEspectaculoTitulo AS Título,
        P_RealizaEspectaculoTipo AS Título,
        P_RealizaEspectaculoProductor AS Título
    FROM 
        Venta
    WHERE 
        ClienteNumero_Visa = p_numeroVisa AND Tipo = 'Pago';
END //

DELIMITER ;

