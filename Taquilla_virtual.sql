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
    Ubicacion VARCHAR(50) PRIMARY KEY,
    Estado ENUM('Libre', 'Deteriorado'), -- Si esta deteriorado no se vende y ya
    Grada VARCHAR(50)
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
    Genero ENUM(
        'Todos_publico',
        'No_infantil',
        'No_jubilado'
    ),
    PRIMARY KEY (Titulo, Tipo, Productor)
);
-- Create Recinto
CREATE TABLE Recinto (
    Nombre VARCHAR(50),
    Fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NumMax INT,
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
    PRIMARY KEY (
        UsuarioTipo,
        LocalidadUbicacion
    ),
    FOREIGN KEY (UsuarioTipo) REFERENCES Usuarios (tipo),
    FOREIGN KEY (LocalidadUbicacion) REFERENCES Localidades (Ubicacion)
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
    R_EspectaculoTitulo VARCHAR(50),
    R_EspectaculoTipo VARCHAR(50),
    R_EspectaculoProductor VARCHAR(50),
    R_RecintoNombre VARCHAR(50),
    R_RecintoFecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (
        OfertaUsuarioTipo,
        OfertaLocalidadUbicacion,
        R_EspectaculoTitulo,
        R_EspectaculoTipo,
        R_EspectaculoProductor,
        R_RecintoNombre,
        R_RecintoFecha
    ),
    FOREIGN KEY (
        OfertaUsuarioTipo,
        OfertaLocalidadUbicacion
    ) REFERENCES Ofertas (
        UsuarioTipo,
        LocalidadUbicacion
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

-- Create Venta Table (relacion ternaria entre Localidades, Clientes y Asociacion{Usuarios, Localidades, Espectaculos y Recinto})
CREATE TABLE Venta (
    ClienteNumero_Visa INT,
    LocalidadUbicacion VARCHAR(50),
    Atributos_Asociacion ??,
    PRIMARY KEY (ClienteNumero_Visa, LocalidadUbicacion, Atributos_Asociacion),
    FOREIGN KEY (ClienteNumero_Visa) REFERENCES Cliente(Numero_Visa),
    FOREIGN KEY (LocalidadUbicacion) REFERENCES Localidades(Ubicacion),
    FOREIGN KEY (Atributos_Asociacion) REFERENCES Pertenecen(...)
);