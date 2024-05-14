DELETE FROM Pertenecen;
INSERT INTO Pertenecen (
    OfertaUsuarioTipo,
    OfertaLocalidadUbicacion,
    OfertaLocalidadGrada,
    R_EspectaculoTitulo,
    R_EspectaculoTipo,
    R_EspectaculoProductor,
    R_RecintoNombre,
    R_RecintoFecha,
    Precio
)
SELECT
    o.UsuarioTipo,
    o.LocalidadUbicacion,
    o.LocalidadGrada,
    r.EspectaculoTitulo,
    r.EspectaculoTipo,
    r.EspectaculoProductor,
    r.RecintoNombre,
    r.RecintoFecha,
    50
FROM
    Ofertas o
CROSS JOIN
    Realiza r 
LIMIT 1000;
