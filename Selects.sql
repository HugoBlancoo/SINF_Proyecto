SELECT * FROM Cliente;
SELECT * FROM Espectaculo;
SELECT * FROM  Recinto ;
SELECT * FROM Localidades;
SELECT * FROM Usuarios;
SELECT * FROM  Ofertas;
SELECT * FROM  Ofertas WHERE UsuarioTipo = 'Infantil';
SELECT * FROM  Realiza;
SELECT * FROM  Realiza WHERE RecintoFecha = '2024-01-10 00:00:00';
SELECT * FROM Permite;
SELECT * FROM  Pertenecen;
SELECT * FROM Venta;
DELETE FROM Permite WHERE EspectaculoTitulo = 'Annie' AND UsuarioTipo = 'Parado';

SELECT * FROM vista_Usuario;
select * FROM vista_Usuario Where R_EspectaculoTitulo = 'Avatar' AND OfertaUsuarioTipo = 'Adulto' AND R_RecintoNombre = 'Recinto1';

