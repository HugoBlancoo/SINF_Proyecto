INSERT INTO Recinto (Nombre, Fecha, Estado)
VALUES 
('Recinto1', '2024-01-01 00:00:00', 'Finalizado'),
('Recinto2', '2024-01-02 00:00:00', 'Abierto'),
('Recinto3', '2024-01-03 00:00:00', 'Cerrado'),
('Recinto4', '2024-01-04 00:00:00', 'Finalizado'),
('Recinto5', '2024-01-05 00:00:00', 'Abierto'),
('Recinto6', '2024-01-06 00:00:00', 'Cerrado'),
('Recinto7', '2024-01-07 00:00:00', 'Finalizado'),
('Recinto8', '2024-01-08 00:00:00', 'Abierto'),
('Recinto9', '2024-01-09 00:00:00', 'Cerrado'),
('Recinto10', '2024-01-10 00:00:00', 'Finalizado');

CREATE TEMPORARY TABLE TempRecinto AS
SELECT r1.Nombre AS Nombre1, r1.Fecha AS Fecha1, r1.Estado AS Estado1, r2.Nombre AS Nombre2, r2.Fecha AS Fecha2, r2.Estado AS Estado2
FROM Recinto r1
JOIN Recinto r2 ON r1.Nombre!= r2.Nombre AND r1.Fecha!= r2.Fecha;

