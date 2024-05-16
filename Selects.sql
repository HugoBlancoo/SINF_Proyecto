-- 1005
SELECT * FROM Cliente;
-- 60
SELECT * FROM Espectaculo;
-- 220
SELECT * FROM  Recinto where Estado = 'Finalizado' AND Fecha = '2024-01-10 00:00:00';
INSERT INTO Localidades (Ubicacion, Estado, Grada) 
SELECT Ubicacion, Estado, CONCAT (Grada,'7') FROM Localidades;
SELECT * FROM Localidades l LEFT JOIN Ofertas o ON l.Ubicacion = o.LocalidadUbicacion AND l.Grada = o.LocalidadGrada WHERE o.LocalidadGrada IS NULL;
INSERT INTO Ofertas (UsuarioTipo, LocalidadUbicacion, LocalidadGrada)
SELECT 'Infantil' ,l.Ubicacion, l.Grada  FROM Localidades l LEFT JOIN Ofertas o ON l.Ubicacion = o.LocalidadUbicacion AND l.Grada = o.LocalidadGrada WHERE o.LocalidadGrada IS NULL;

-- 4
SELECT * FROM Usuarios;
-- 5400
SELECT * FROM  Ofertas;
SELECT * FROM  Ofertas WHERE UsuarioTipo = 'Infantil';
-- 13200
SELECT * FROM  Realiza;
SELECT * FROM  Realiza WHERE EspectaculoTitulo = 'El Rey Leon' AND RecintoFecha = '2024-01-10 00:00:00';
-- 239
SELECT * FROM Permite;
SELECT * FROM  Pertenecen;
-- 3 240 000
SELECT * FROM  Pertenecen WHERE OfertaUsuarioTipo = 'Infantil' AND R_EspectaculoTitulo = 'El Rey Leon';
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
)SELECT 'Infantil', b.LocalidadUbicacion, b.LocalidadGrada ,a.EspectaculoTitulo, a.EspectaculoTipo, a.EspectaculoProductor, a.RecintoNombre,  a.RecintoFecha, 75 FROM  (SELECT * FROM Realiza WHERE EspectaculoTitulo = 'El Rey Leon' AND RecintoFecha = '2024-01-10 00:00:00' LIMIT 1) a JOIN (SELECT * FROM Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada LIKE '%6') b;
SELECT * FROM (SELECT * FROM  Realiza WHERE EspectaculoTitulo = 'El Rey Leon' AND RecintoFecha = '2024-01-10 00:00:00' LIMIT 1) a JOIN (SELECT * FROM Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada LIKE '%4') b;
SELECT 'Infantil', b.LocalidadUbicacion, b.LocalidadGrada ,a.EspectaculoTitulo, a.EspectaculoTipo, a.EspectaculoProductor, a.RecintoNombre,  a.RecintoFecha, 75 FROM  (SELECT * FROM Realiza WHERE EspectaculoTitulo = 'El Rey Leon' AND RecintoFecha = '2024-01-10 00:00:00' LIMIT 1) a JOIN (SELECT * FROM Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada LIKE '%4') b;
SELECT * FROM Venta ;
SELECT * FROM Venta WHERE Tipo = 'Pago';
DELETE FROM Permite WHERE EspectaculoTitulo = 'Annie' AND UsuarioTipo = 'Parado';

SELECT * FROM vista_Usuario;
select COUNT(*) FROM vista_Usuario Where R_EspectaculoTitulo = 'El Rey Leon' AND OfertaUsuarioTipo = 'Infantil' ;

