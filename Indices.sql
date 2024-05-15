-- Indice para Usuarios
-- No necesita índices adicionales ya que tipo es la clave primaria.

-- Indice para Localidades
CREATE INDEX idx_localidades_grada ON Localidades (Grada);

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
CREATE INDEX idx_realiza_espectaculo ON Realiza (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor);
CREATE INDEX idx_realiza_recinto ON Realiza (RecintoNombre, RecintoFecha);

-- Indice para Ofertas
CREATE INDEX idx_ofertas_localidad ON Ofertas (LocalidadUbicacion, LocalidadGrada);

-- Indice para Permiten
CREATE INDEX idx_permite_espectaculo ON Permite (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor);

-- Indice para Pertenecen
CREATE INDEX idx_pertenecen_oferta ON Pertenecen (OfertaUsuarioTipo, OfertaLocalidadUbicacion, OfertaLocalidadGrada);
CREATE INDEX idx_pertenecen_realiza ON Pertenecen (R_EspectaculoTitulo, R_EspectaculoTipo, R_EspectaculoProductor, R_RecintoNombre, R_RecintoFecha);

-- Indice para Venta
CREATE INDEX idx_venta_cliente ON Venta (ClienteNumero_Visa);
CREATE INDEX idx_venta_localidad ON Venta (LocalidadUbicacion, LocalidadGrada);
CREATE INDEX idx_venta_oferta ON Venta (P_OfertaUsuarioTipo, P_OfertaLocalidadUbicacion, P_OferataLocalidadGrada);
CREATE INDEX idx_venta_realiza ON Venta (P_RealizaEspectaculoTitulo, P_RealizaEspectaculoTipo, P_RealizaEspectaculoProductor, P_RealizaRecintoNombre, P_RealizaRecintoFecha); 
