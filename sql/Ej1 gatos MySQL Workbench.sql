

USE veterinaria; -- selecciona la bbdd
CREATE TABLE gatos (
    -- porque solo es una veterinaria de gatos
    id_gato INT PRIMARY KEY,
    nombre VARCHAR(15) NOT NULL,
    raza VARCHAR(15),
    sexo ENUM ('Hembra','Macho') COMMENT 'comentario'
);

DESCRIBE gatos;

CREATE TABLE visitas(
    id_gato INT NOT NULL,
    fecha_visita DATE NOT NULL,
    motivo VARCHAR(100),
    PRIMARY KEY (id_gato, fecha_visita),
    FOREIGN KEY (id_gato)
       REFERENCES gatos (id_gato)
       ON UPDATE CASCADE
       ON DELETE RESTRICT
);