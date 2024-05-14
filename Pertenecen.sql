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
    CASE o.UsuarioTipo
        WHEN 'Infantil' THEN 25
        WHEN 'Jubilado' THEN 30
        WHEN 'Adulto' THEN 50
        WHEN 'Parado' THEN 20
        ELSE 100  -- Precio por defecto si no se encuentra el tipo de usuario
    END AS Precio
FROM
   Ofertas o
CROSS JOIN
    (SELECT * FROM Realiza WHERE RecintoFecha = '2024-01-10 00:00:00') r;
