DELETE FROM `Recinto`;
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
('Recinto10', '2024-01-10 00:00:00', 'Finalizado'),
('Recinto1', '2024-01-01 17:30:00', 'Finalizado'),
('Recinto2', '2024-01-02 20:00:00', 'Abierto'),
('Recinto3', '2024-01-03 15:45:00', 'Cerrado'),
('Recinto4', '2024-01-04 21:15:00', 'Finalizado'),
('Recinto5', '2024-01-05 10:00:00', 'Abierto'),
('Recinto6', '2024-01-06 08:30:00', 'Cerrado'),
('Recinto7', '2024-01-07 09:40:00', 'Finalizado'),
('Recinto8', '2024-01-08 14:15:00', 'Abierto'),
('Recinto9', '2024-01-09 23:10:00', 'Cerrado'),
('Recinto10', '2024-01-10 22:50:00', 'Finalizado');

INSERT INTO Recinto (Nombre, Fecha, Estado)
SELECT 
    CONCAT('Recinto', t2.num) AS Nombre,
    DATE_ADD(r.Fecha, INTERVAL t2.num DAY) AS Fecha,
    CASE 
        WHEN MOD(t2.num, 3) = 0 THEN 'Finalizado'
        WHEN MOD(t2.num, 3) = 1 THEN 'Abierto'
        ELSE 'Cerrado'
    END AS Estado
FROM 
    Recinto r
    JOIN (
        SELECT 1 AS num UNION ALL
        SELECT 2 UNION ALL
        SELECT 3 UNION ALL
        SELECT 4 UNION ALL
        SELECT 5 UNION ALL
        SELECT 6 UNION ALL
        SELECT 7 UNION ALL
        SELECT 8 UNION ALL
        SELECT 9 UNION ALL
        SELECT 10
    ) t2 ON 1=1;
