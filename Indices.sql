-- EJECUTARLAS UNO A UNO EN LA TERMINAL

-- Indice para Usuarios
-- No necesita índices adicionales ya que tipo es la clave primaria.

-- Indice para Localidades
DROP INDEX idx_localidades_grada ON Recinto;
EXPLAIN SELECT * FROM Localidades WHERE Grada = 'Grada1';
CREATE INDEX idx_localidades_grada ON Localidades (Grada);
EXPLAIN SELECT * FROM Localidades WHERE Grada = 'Grada1';

-- Indice para Clientes
-- No necesita índices adicionales ya que nro Visa es la clave primaria.

-- Indice para Espectaculo
-- La tabla Espectaculo tiene una clave primaria compuesta, por lo que tampoco necesita índices adicionales a menos que frecuentemente se hagan consultas sobre columnas individuales.

-- Indice para Recinto
DROP INDEX idx_recinto_estado ON Recinto;
EXPLAIN SELECT * FROM Recinto WHERE Estado = 'Abierto';
CREATE INDEX idx_recinto_estado ON Recinto (Estado);
EXPLAIN SELECT * FROM Recinto WHERE Estado = 'Abierto';

-- Indice para Realiza
--  Eliminar indice
DROP INDEX idx_realiza_espectaculo ON Realiza;
ALTER TABLE Realiza DROP FOREIGN KEY Realiza_ibfk_2;
DROP INDEX idx_realiza_recinto ON Realiza;
ALTER TABLE Realiza ADD CONSTRAINT Realiza_ibfk_2 FOREIGN KEY (RecintoNombre, RecintoFecha) REFERENCES Recinto (Nombre, Fecha);

--  Probar rendimento de los indices
EXPLAIN SELECT * FROM Realiza WHERE EspectaculoTitulo = 'Annie';
CREATE INDEX idx_realiza_espectaculo ON Realiza (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor);
CREATE INDEX idx_realiza_recinto ON Realiza (RecintoNombre, RecintoFecha);
EXPLAIN SELECT * FROM Realiza WHERE EspectaculoTitulo = 'Annie';


-- Indice para Ofertas
--  Eliminar indice
ALTER TABLE Ofertas DROP FOREIGN KEY Ofertas_ibfk_2;
DROP INDEX idx_ofertas_usuariotipo_localidad ON Ofertas;
ALTER TABLE Ofertas ADD CONSTRAINT Ofertas_ibfk_2 FOREIGN KEY (LocalidadUbicacion, LocalidadGrada) REFERENCES Localidades (Ubicacion, Grada);

--  Probar rendimento de los indices
EXPLAIN SELECT * FROM Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada = 'Grada1';
CREATE INDEX idx_ofertas_usuariotipo_localidad ON Ofertas (UsuarioTipo, LocalidadGrada);
EXPLAIN SELECT * FROM Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada = 'Grada1';

-- Indice para Permiten
--  Eliminar indice
ALTER TABLE Permite DROP FOREIGN KEY Permite_ibfk_2;
DROP INDEX idx_permite_espectaculo ON Permite;
ALTER TABLE Permite ADD CONSTRAINT Permite_ibfk_2 FOREIGN KEY (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor)
REFERENCES Espectaculo (Titulo, Tipo, Productor);

--  Probar rendimiento de los indices
EXPLAIN SELECT * FROM Permite WHERE UsuarioTipo = 'Infantil';
CREATE INDEX idx_permite_espectaculo ON Permite (UsuarioTipo);
EXPLAIN SELECT * FROM Permite WHERE EspectaculoTitulo = 'Annie';

-- Indice para Pertenecen
CREATE INDEX idx_pertenecen_oferta ON Pertenecen (OfertaUsuarioTipo, OfertaLocalidadUbicacion, OfertaLocalidadGrada);
CREATE INDEX idx_pertenecen_realiza ON Pertenecen (R_EspectaculoTitulo, R_EspectaculoTipo, R_EspectaculoProductor, R_RecintoNombre, R_RecintoFecha);

-- Indice para Venta
CREATE INDEX idx_venta_cliente ON Venta (ClienteNumero_Visa);
CREATE INDEX idx_venta_localidad ON Venta (LocalidadUbicacion, LocalidadGrada);
CREATE INDEX idx_venta_oferta ON Venta (P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada);
CREATE INDEX idx_venta_realiza ON Venta (P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, P_RealizaRecintoNombre, P_RealizaRecintoFecha); 
