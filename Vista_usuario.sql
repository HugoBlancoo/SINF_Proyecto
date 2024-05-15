-- Prueba para Vistas
-- Hacer con root : mysql -u root -p'Sinf510_5'
Create user 'user'@'localhost' Identified by 'Pass12_12';
REVOKE ALL PRIVILEGES ON Taquilla.* FROM 'user'@'localhost';
GRANT SELECT ON Taquilla.vista_Usuario TO 'user'@'localhost';
-- mysql -u user -p'Pass12_12'

DROP VIEW IF EXISTS vista_Usuario;

CREATE VIEW vista_Usuario AS
SELECT P.*
FROM Pertenecen P
LEFT JOIN Venta V ON 
    P.OfertaLocalidadUbicacion = V.P_OfertaLocalidadUbicacion AND
    P.OfertaLocalidadGrada = V.P_OferataLocalidadGrada AND
    P.R_EspectaculoTitulo = V.P_RealizaEspectaculoTitulo AND
    P.R_EspectaculoTipo = V.P_RealizaEspectaculoTipo AND
    P.R_EspectaculoProductor = V.P_RealizaEspectaculoProductor AND
    P.R_RecintoNombre = V.P_RealizaRecintoNombre AND
    P.R_RecintoFecha = V.P_RealizaRecintoFecha
LEFT JOIN Recinto R ON P.R_RecintoNombre = R.Nombre AND P.R_RecintoFecha = R.Fecha
LEFT JOIN Permite Per ON 
    Per.EspectaculoTitulo = P.R_EspectaculoTitulo AND
    Per.EspectaculoTipo = P.R_EspectaculoTipo AND
    Per.EspectaculoProductor = P.R_EspectaculoProductor AND
    Per.UsuarioTipo = P.OfertaUsuarioTipo
WHERE 
    V.P_OfertaLocalidadUbicacion IS NULL
    AND (R.Estado IS NULL OR R.Estado NOT IN ('Cerrado', 'Finalizado'))
    AND Per.UsuarioTipo IS NOT NULL;

