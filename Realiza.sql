DELETE FROM Realiza;
INSERT INTO Realiza (EspectaculoTitulo, EspectaculoTipo, EspectaculoProductor, RecintoNombre, RecintoFecha)
SELECT 
    e.Titulo,
    e.Tipo,
    e.Productor,
    r.Nombre,
    r.Fecha
FROM 
    Espectaculo e
    CROSS JOIN Recinto r;
