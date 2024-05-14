DELETE FROM `Permite`;
INSERT INTO Permite (UsuarioTipo, EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor)
SELECT
    u.tipo AS UsuarioTipo,
    e.Titulo AS EspectaculoTitulo,
    e.Tipo AS EspectaculoTipo,
    e.Productor AS EspectaculoProductor
FROM
    Usuarios u
CROSS JOIN
    Espectaculo e;
