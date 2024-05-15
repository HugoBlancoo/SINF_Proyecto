-- Probar Comprar_localidad
DELETE FROM Venta;
SELECT * FROM Venta;
-- 1º Un caso que funcione
CALL comprar_localidad(286, 'F1C1', 'Grada1', 'Adulto', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00', 'Pago');
CALL comprar_localidad(286, 'F3C1', 'Grada1', 'Jubilado', 'Avatar', 'Película', '20th Century Studios','Recinto1', '2024-01-10 00:00:00', 'Pago');

-- 2º Probamos la misma localidad pero otro tipo de usuario
CALL comprar_localidad(286, 'F1C1', 'Grada1', 'Infantil', 'Avatar', 'Película', '20th Century Studios','Recinto1', '2024-01-10 00:00:00', 'Pago');
-- 3º Probamos si el cliente no existe
CALL comprar_localidad(1, 'F1C1', 'Grada2', 'Infantil', 'Avatar', 'Película', '20th Century Studios','Recinto1', '2024-01-10 00:00:00', 'Pago');
-- 4º Probamos a comprar una localidad en un recinto Cerrado/Finalizado
CALL comprar_localidad(286, 'F1C1', 'Grada2', 'Infantil', 'Avatar', 'Película', '20th Century Studios','Recinto10', '2024-01-10 00:00:00', 'Pago');
-- 5º Probamos a comprar para un tipo de usuario no permitido
CALL comprar_localidad(286, 'F1C1', 'Grada2', 'Parado', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00', 'Pago');

-- Hacemos una reserva
CALL comprar_localidad(286, 'F1C2', 'Grada1', 'Adulto', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00', 'Reserva');


--  Probar Anular Reserva 
SELECT * FROM Venta;
-- 1º Otro cliente intenta anular la reserva de otro
CALL AnularReserva(998, 'F1C2', 'Grada1', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00');
-- 2º Intentas anular una reserva que no tienes
CALL AnularReserva(286, 'F1C1', 'Grada1', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00');
-- 3º Hacemos la anulacion
CALL AnularReserva(286, 'F1C2', 'Grada1', 'Annie', 'Musical', 'Martin Charnin','Recinto1', '2024-01-10 00:00:00');
CALL TotalRecaudadoPorEspectaculo();

-- Ver que entradas tienes comprado
CALL VerEntradasCompradasPorCliente(286);
-- Ver que Espectáculos hay en el Recinto1 a una determinada fecha
CALL VerEspectaculosEnRecinto('Recinto1','2024-01-01 00:00:00');
-- Ver que espectaculos hay para un tipo de Usuario
CALL VerEspectaculosPorTipoUsuario('Infantil');

