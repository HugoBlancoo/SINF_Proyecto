CREATE VIEW vista_Usuario AS

SELECT P.*
FROM Pertenecen P
LEFT JOIN Venta V ON
    P.OfertaUsuarioTipo = V.P_OfertaUsuarioTipo AND
    P.OfertaLocalidadUbicacion = V.P_OfertaLocalidadUbicacion AND
    P.OfertaLocalidadGrada = V.P_OferataLocalidadGrada AND
    P.R_EspectaculoTitulo = V.P_RealizaEspectaculoTitulo AND
    P.R_EspectaculoTipo = V.P_RealizaEspectaculoTipo AND
    P.R_EspectaculoProductor = V.P_RealizaEspectaculoProductor AND
    P.R_RecintoNombre = V.P_RealizaRecintoNombre AND
    P.R_RecintoFecha = V.P_RealizaRecintoFecha
WHERE V.P_OfertaUsuarioTipo IS NULL;
