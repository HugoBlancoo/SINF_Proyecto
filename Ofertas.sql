DELETE FROM Ofertas;
INSERT INTO Ofertas (UsuarioTipo, LocalidadUbicacion, LocalidadGrada)
SELECT u.tipo, l.Ubicacion, l.Grada
FROM Usuarios u
CROSS JOIN Localidades l;
