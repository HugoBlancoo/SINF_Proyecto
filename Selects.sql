SELECT * FROM Cliente;
SELECT * FROM Espectaculo;
SELECT * FROM  Recinto WHERE Fecha = '2024-01-10 00:00:00';
SELECT * FROM Localidades;
SELECT * FROM Usuarios;
SELECT * FROM  Ofertas;
SELECT * FROM  Ofertas WHERE UsuarioTipo = 'Infantil' AND LocalidadGrada = 'Grada1';
SELECT * FROM  Realiza;
SELECT * FROM  Realiza WHERE RecintoFecha = '2024-01-10 00:00:00';
SELECT * FROM Permite;
SELECT * FROM  Pertenecen WHERE R_EspectaculoTitulo = 'Annie' AND OfertaUsuarioTipo = 'Infantil';
SELECT * FROM Venta;
DELETE FROM Permite WHERE EspectaculoTitulo = 'Annie' AND UsuarioTipo = 'Parado';