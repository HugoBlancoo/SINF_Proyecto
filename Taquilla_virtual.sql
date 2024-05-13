DROP DATABASE IF EXISTS Taquilla_Virtual;

CREATE DATABASE Taquilla_Virtual;

use Taquilla_Virtual;

DROP TABLE IF EXISTS Usuarios;

DROP TABLE IF EXISTS Localidades;

DROP TABLE IF EXISTS Cliente;

DROP TABLE IF EXISTS Espectaculo;

DROP TABLE IF EXISTS Recinto;

DROP TABLE IF EXISTS Realiza;

DROP TABLE IF EXISTS Ofertas;

DROP TABLE IF EXISTS Pertenecen;

DROP TABLE IF EXISTS Venta;

DROP TABLE IF EXISTS Permite;

-- ++++++++++++++++++++++++++++++++ TABLAS ++++++++++++++++++++++++++++++++
-- Create Usuarios Table
CREATE TABLE Usuarios (
    tipo ENUM(
        'Infantil',
        'Jubilado',
        'Adulto',
        'Parado'
    ) PRIMARY KEY
);
-- Create Localidades Table
CREATE TABLE Localidades (
    Ubicacion VARCHAR(50),
    Estado ENUM('Libre', 'Deteriorado'), -- Si esta deteriorado no se vende y ya
    Grada VARCHAR(50),
    PRIMARY KEY (Ubicacion, Grada)
);
-- Create Cliente Table
CREATE TABLE Cliente (
    Numero_Visa INT PRIMARY KEY,
    Nombre VARCHAR(50)
);
-- Create Espectaculo Table
CREATE TABLE Espectaculo (
    Titulo VARCHAR(50),
    Tipo VARCHAR(50),
    Productor VARCHAR(50),
    PRIMARY KEY (Titulo, Tipo, Productor)
);
-- Create Recinto
CREATE TABLE Recinto (
    Nombre VARCHAR(50),
    Fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM(
        'Finalizado',
        'Abierto',
        'Cerrado'
    ),
    PRIMARY KEY (Nombre, Fecha)
);
-- ++++++++++++++++++++++++++++++++ RELACIONES ++++++++++++++++++++++++++++++++
-- Create Realiza Table (relacion entre Espectaculo y Recinto)
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
    FOREIGN KEY (
        EspectaculoTitulo,
        EspectaculoTipo,
        EspectaculoProductor
    ) REFERENCES Espectaculo (Titulo, Tipo, Productor),
    FOREIGN KEY (RecintoNombre, RecintoFecha) REFERENCES Recinto (Nombre, Fecha)
);

-- Create Ofertas Table (relacion entre Usuario y Localidades)
CREATE TABLE Ofertas (
    UsuarioTipo ENUM(
        'Infantil',
        'Jubilado',
        'Adulto',
        'Parado'
    ),
    LocalidadUbicacion VARCHAR(50),
    LocalidadGrada VARCHAR(50),
    PRIMARY KEY (
        UsuarioTipo,
        LocalidadUbicacion,
        LocalidadGrada
    ),
    FOREIGN KEY (UsuarioTipo) REFERENCES Usuarios (tipo),
    FOREIGN KEY (LocalidadUbicacion,LocalidadGrada) REFERENCES Localidades (Ubicacion,Grada)
);

-- Create Permite Table (relacion entre Usuario y Espectaculo)
CREATE TABLE Permite (
    UsuarioTipo ENUM(
        'Infantil',
        'Jubilado',
        'Adulto',
        'Parado'
    ),
    EspectaculoTitulo VARCHAR(50),
    EspectaculoTipo VARCHAR(50),
    EspectaculoProductor VARCHAR(50),
    PRIMARY KEY (
        UsuarioTipo,
        EspectaculoTitulo,
        EspectaculoTipo,
        EspectaculoProductor
    ),
    FOREIGN KEY (UsuarioTipo) REFERENCES Usuarios (tipo),
    FOREIGN KEY (
        EspectaculoTitulo,
        EspectaculoTipo,
        EspectaculoProductor
<<<<<<< Updated upstream
    ) REFERENCES Espectaculo (Titulo, Tipo, Productor)
=======
    ) REFERENCES Espectaculo (
        Titulo,
        Tipo,
        Productor
    )
>>>>>>> Stashed changes
);

-- Create Pertenecen Table (relacion entre Ofertas y Realizaciones)
CREATE TABLE Pertenecen (
    OfertaUsuarioTipo ENUM(
        'Infantil',
        'Jubilado',
        'Adulto',
        'Parado'
    ),
    OfertaLocalidadUbicacion VARCHAR(50),
    OfertaLocalidadGrada VARCHAR(50),
    R_EspectaculoTitulo VARCHAR(50),
    R_EspectaculoTipo VARCHAR(50),
    R_EspectaculoProductor VARCHAR(50),
    R_RecintoNombre VARCHAR(50),
    R_RecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Precio INT,
    PRIMARY KEY (
        OfertaUsuarioTipo,
        OfertaLocalidadUbicacion,
        OfertaLocalidadGrada,
        R_EspectaculoTitulo,
        R_EspectaculoTipo,
        R_EspectaculoProductor,
        R_RecintoNombre,
        R_RecintoFecha
    ),
    FOREIGN KEY (
        OfertaUsuarioTipo,
        OfertaLocalidadUbicacion,
        OfertaLocalidadGrada
    ) REFERENCES Ofertas (
        UsuarioTipo,
        LocalidadUbicacion,
        LocalidadGrada
    ),
    FOREIGN KEY (
        R_EspectaculoTitulo,
        R_EspectaculoTipo,
        R_EspectaculoProductor,
        R_RecintoNombre,
        R_RecintoFecha
    ) REFERENCES Realiza (
        EspectaculoTitulo,
        EspectaculoTipo,
        EspectaculoProductor,
        RecintoNombre,
        RecintoFecha
    )
);

-- Create Venta Table (relacion ternaria entre Localidades, Clientes y Pertenecen {Usuarios, Localidades, Espectaculos y Recinto})
CREATE TABLE Venta (
    ClienteNumero_Visa INT,
    LocalidadUbicacion VARCHAR(50),
    LocalidadGrada VARCHAR(50),
    P_OfertaUsuarioTipo ENUM(
        'Infantil',
        'Jubilado',
        'Adulto',
        'Parado'
    ),
    P_OfertaLocalidadUbicacion VARCHAR(50),
    P_OferataLocalidadGrada VARCHAR(50),
    P_RealizaEspectaculoTitulo VARCHAR(50),
    P_RealizaEspectaculoTipo VARCHAR(50),
    P_RealizaEspectaculoProductor VARCHAR(50),
    P_RealizaRecintoNombre VARCHAR(50),
    P_RealizaRecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Tipo ENUM('Reserva', 'Pago'),
    PRIMARY KEY (
        ClienteNumero_Visa,
        LocalidadUbicacion,
        LocalidadGrada,
        P_OfertaUsuarioTipo,
        P_OfertaLocalidadUbicacion,
        P_OferataLocalidadGrada,
        P_RealizaEspectaculoTitulo,
        P_RealizaEspectaculoTipo,
        P_RealizaEspectaculoProductor,
        P_RealizaRecintoNombre,
        P_RealizaRecintoFecha
    ),
    FOREIGN KEY (ClienteNumero_Visa) REFERENCES Cliente (Numero_Visa),
    FOREIGN KEY (LocalidadUbicacion, LocalidadGrada) REFERENCES Localidades (Ubicacion, Grada),
    FOREIGN KEY (
        P_OfertaUsuarioTipo,
        P_OfertaLocalidadUbicacion,
        P_OferataLocalidadGrada,
        P_RealizaEspectaculoTitulo,
        P_RealizaEspectaculoTipo,
        P_RealizaEspectaculoProductor,
        P_RealizaRecintoNombre,
        P_RealizaRecintoFecha
    ) REFERENCES Pertenecen (
        OfertaUsuarioTipo,
        OfertaLocalidadUbicacion,
        OfertaLocalidadGrada,
        R_EspectaculoTitulo,
        R_EspectaculoTipo,
        R_EspectaculoProductor,
        R_RecintoNombre,
        R_RecintoFecha
    )
<<<<<<< Updated upstream
);
=======
);
>>>>>>> Stashed changes
