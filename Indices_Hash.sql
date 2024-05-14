-- Crear tabla Usuarios con motor MEMORY
CREATE TABLE Usuarios (
    tipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado') PRIMARY KEY
) ENGINE=MEMORY;

-- Crear tabla Localidades con motor MEMORY
CREATE TABLE Localidades (
    Ubicacion VARCHAR(50),
    Grada VARCHAR(50),
    PRIMARY KEY (Ubicacion, Grada)
) ENGINE=MEMORY;

-- Crear tabla Cliente con motor MEMORY
CREATE TABLE Cliente (
    Numero_Visa INT PRIMARY KEY,
    Nombre VARCHAR(50)
) ENGINE=MEMORY;

-- Crear tabla Espectaculo con motor MEMORY
CREATE TABLE Espectaculo (
    Titulo VARCHAR(50),
    Tipo VARCHAR(50),
    Productor VARCHAR(50),
    PRIMARY KEY (Titulo, Tipo, Productor)
) ENGINE=MEMORY;

-- Crear tabla Recinto con motor MEMORY
CREATE TABLE Recinto (
    Nombre VARCHAR(50),
    Fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM('Finalizado', 'Abierto', 'Cerrado'),
    PRIMARY KEY (Nombre, Fecha)
) ENGINE=MEMORY;

-- Crear tabla Realiza con motor MEMORY
CREATE TABLE Realiza (
    EspectaculoTitulo VARCHAR(50),
    EspectaculoTipo VARCHAR(50),
    EspectaculoProductor VARCHAR(50),
    RecintoNombre VARCHAR(50),
    RecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (
        EspectaculoTitulo,
        EspectaculoTipo,
        EspectaculoProductor,
        RecintoNombre,
        RecintoFecha
    ),
    FOREIGN KEY (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor) REFERENCES Espectaculo (Titulo, Tipo, Productor),
    FOREIGN KEY (RecintoNombre, RecintoFecha) REFERENCES Recinto (Nombre, Fecha)
) ENGINE=MEMORY;

-- Crear tabla Ofertas con motor MEMORY
CREATE TABLE Ofertas (
    UsuarioTipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado'),
    LocalidadUbicacion VARCHAR(50),
    LocalidadGrada VARCHAR(50),
    PRIMARY KEY (UsuarioTipo, LocalidadUbicacion, LocalidadGrada),
    FOREIGN KEY (UsuarioTipo) REFERENCES Usuarios (tipo),
    FOREIGN KEY (LocalidadUbicacion, LocalidadGrada) REFERENCES Localidades (Ubicacion, Grada)
) ENGINE=MEMORY;

-- Crear tabla Permite con motor MEMORY
CREATE TABLE Permite (
    UsuarioTipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado'),
    EspectaculoTitulo VARCHAR(50),
    EspectaculoTipo VARCHAR(50),
    EspectaculoProductor VARCHAR(50),
    PRIMARY KEY (UsuarioTipo, EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor),
    FOREIGN KEY (UsuarioTipo) REFERENCES Usuarios (tipo),
    FOREIGN KEY (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor) REFERENCES Espectaculo (Titulo, Tipo, Productor)
) ENGINE=MEMORY;

-- Crear tabla Pertenecen con motor MEMORY
CREATE TABLE Pertenecen (
    OfertaUsuarioTipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado'),
    OfertaLocalidadUbicacion VARCHAR(50),
    OfertaLocalidadGrada VARCHAR(50),
    R_EspectaculoTitulo VARCHAR(50),
    R_EspectaculoTipo VARCHAR(50),
    R_EspectaculoProductor VARCHAR(50),
    R_RecintoNombre VARCHAR(50),
    R_RecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Precio INT,
    PRIMARY KEY (OfertaUsuarioTipo, OfertaLocalidadUbicacion, OfertaLocalidadGrada, R_EspectaculoTitulo, R_EspectaculoTipo, R_EspectaculoProductor, R_RecintoNombre, R_RecintoFecha),
    FOREIGN KEY (OfertaUsuarioTipo, OfertaLocalidadUbicacion, OfertaLocalidadGrada) REFERENCES Ofertas (UsuarioTipo, LocalidadUbicacion, LocalidadGrada),
    FOREIGN KEY (R_EspectaculoTitulo, R_EspectaculoTipo, R_EspectaculoProductor, R_RecintoNombre, R_RecintoFecha) REFERENCES Realiza (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor, RecintoNombre, RecintoFecha)
) ENGINE=MEMORY;

-- Crear tabla Venta con motor MEMORY
CREATE TABLE Venta (
    ClienteNumero_Visa INT,
    LocalidadUbicacion VARCHAR(50),
    LocalidadGrada VARCHAR(50),
    P_OfertaUsuarioTipo ENUM('Infantil', 'Jubilado', 'Adulto', 'Parado'),
    P_OfertaLocalidadUbicacion VARCHAR(50),
    P_OferataLocalidadGrada VARCHAR(50),
    P_RealizaEspectaculoTitulo VARCHAR(50),
    P_RealizaEspectaculoTipo VARCHAR(50),
    P_RealizaEspectaculoProductor VARCHAR(50),
    P_RealizaRecintoNombre VARCHAR(50),
    P_RealizaRecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Tipo ENUM('Reserva', 'Pago'),
    PRIMARY KEY (ClienteNumero_Visa, LocalidadUbicacion, LocalidadGrada, P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada, P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, P_RealizaRecintoNombre, P_RealizaRecintoFecha),
    FOREIGN KEY (ClienteNumero_Visa) REFERENCES Cliente (Numero_Visa),
    FOREIGN KEY (LocalidadUbicacion, LocalidadGrada) REFERENCES Localidades (Ubicacion, Grada),
    FOREIGN KEY (P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada, P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, P_RealizaRecintoNombre, P_RealizaRecintoFecha) REFERENCES Pertenecen (OfertaUsuarioTipo, OfertaLocalidadUbicacion, OfertaLocalidadGrada, R_EspectaculoTitulo, R_EspectaculoTipo, R_EspectaculoProductor, R_RecintoNombre, R_RecintoFecha)
) ENGINE=MEMORY;

-- Índices Hash en las tablas

-- Índice Hash en Usuarios.tipo
CREATE INDEX idx_hash_usuarios_tipo ON Usuarios (tipo) USING HASH;

-- Índice Hash en Localidades.Ubicacion
CREATE INDEX idx_hash_localidades_ubicacion ON Localidades (Ubicacion) USING HASH;

-- Índice Hash en Localidades.Grada
CREATE INDEX idx_hash_localidades_grada ON Localidades (Grada) USING HASH;

-- Índice Hash en Cliente.Nombre
CREATE INDEX idx_hash_cliente_nombre ON Cliente (Nombre) USING HASH;

-- Índice Hash en Espectaculo.Tipo
CREATE INDEX idx_hash_espectaculo_tipo ON Espectaculo (Tipo) USING HASH;

-- Índice Hash en Espectaculo.Productor
CREATE INDEX idx_hash_espectaculo_productor ON Espectaculo (Productor) USING HASH;

-- Índice Hash en Recinto.Estado
CREATE INDEX idx_hash_recinto_estado ON Recinto (Estado) USING HASH;

-- Índice Hash en Realiza.EspectaculoTitulo
CREATE INDEX idx_hash_realiza_espectaculo_titulo ON Realiza (EspectaculoTitulo) USING HASH;

-- Índice Hash en Realiza.RecintoNombre
CREATE INDEX idx_hash_realiza_recinto_nombre ON Realiza (RecintoNombre) USING HASH;

-- Índice Hash en Ofertas.UsuarioTipo
CREATE INDEX idx_hash_ofertas_usuario_tipo ON Ofertas (UsuarioTipo) USING HASH;

-- Índice Hash en Ofertas.LocalidadUbicacion
CREATE INDEX idx_hash_ofertas_localidad_ubicacion ON Ofertas (LocalidadUbicacion) USING HASH;

-- Índice Hash en Ofertas.LocalidadGrada
CREATE INDEX idx_hash_ofertas_localidad_grada ON Ofertas (LocalidadGrada) USING HASH;

-- Índice Hash en Permite.UsuarioTipo
CREATE INDEX idx_hash_permite_usuario_tipo ON Permite (UsuarioTipo) USING HASH;

-- Índice Hash en Permite.EspectaculoTitulo
