INSERT INTO Espectaculo (Titulo, Tipo, Productor) 
VALUES 
    ('El Rey León', 'Musical', 'Disney Theatrical Productions'),
    ('La La Land in Concert', 'Concierto', 'Summit Entertainment'),
    ('El Fantasma de la Ópera', 'Musical', 'Cameron Mackintosh'),
    ('The Rolling Stones: No Filter Tour', 'Concierto', 'AEG Presents'),
    ('Harry Potter and the Cursed Child', 'Teatro', 'Sonia Friedman Productions'),
    ('U2: The Joshua Tree Tour', 'Concierto', 'Live Nation'),
    ('Hamilton', 'Musical', 'Lin-Manuel Miranda'),
    ('Cirque du Soleil: Luzia', 'Espectáculo de Circo', 'Cirque du Soleil'),
    ('Michael Jackson: The Immortal World Tour', 'Concierto', 'Cirque du Soleil'),
    ('Game of Thrones Live Concert Experience', 'Concierto', 'Live Nation');


INSERT INTO EspectaculoAux (Titulo, Tipo, Productor) 
VALUES 
    ('U2: The Joshua Tree Tour', 'Concierto', 'Live Nation'),
    ('Hamilton', 'Musical', 'Lin-Manuel Miranda'),
    ('Cirque du Soleil: Luzia', 'Espectáculo de Circo', 'Cirque du Soleil'),
    ('Michael Jackson: The Immortal World Tour', 'Concierto', 'Cirque du Soleil'),
    ('Game of Thrones Live Concert Experience', 'Concierto', 'Live Nation');


SELECT *
FROM Espectaculo
CROSS JOIN EspectaculoAux;

SELECT *
FROM EspectaculoAux
CROSS JOIN Espectaculo;

