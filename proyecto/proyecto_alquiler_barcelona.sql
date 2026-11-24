CREATE DATABASE IF NOT EXISTS alquiler_barcelona 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
USE alquiler_barcelona;

-- ============================================================================
-- PROYECTO: Base de datos sobre viviendas en alquiler
-- OBJETIVO: Organizar información estadística existente sobre alquiler
-- de viviendas por territorio y año.
-- FUENTES OFICIALES:
-- 1) https://www.barcelona.cat/habitatge/es/recursos/vivienda-en-datos
-- 2) https://portaldades.ajuntament.barcelona.cat/es/estad%C3%ADsticas/b37xv8wcjh
-- CSV de trabajo: alquiler_normalizado.csv
-- Columnas del CSV: territorio, anio, precio_medio_eur_mes.
-- Unidad: EUR/mes. Son valores estadísticos agregados, no anuncios
-- ni registros individuales de viviendas.
-- Los valores ausentes se omiten; nunca se sustituyen por cero.
-- ============================================================================


CREATE TABLE territorio (
  id_territorio INT AUTO_INCREMENT PRIMARY KEY,
  nombre_territorio VARCHAR(150) NOT NULL,
  tipo_territorio ENUM('comunidad_autonoma','area_metropolitana','municipio','distrito','barrio') NOT NULL,
  id_padre INT NULL,
  CONSTRAINT uq_territorio_nombre_padre UNIQUE (nombre_territorio, id_padre),
  CONSTRAINT fk_territorio_padre FOREIGN KEY (id_padre) REFERENCES territorio(id_territorio) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE periodo (
  anio SMALLINT PRIMARY KEY
);

CREATE TABLE indicador (
  id_indicador INT AUTO_INCREMENT PRIMARY KEY,
  nombre_indicador VARCHAR(150) NOT NULL,
  unidad_medida VARCHAR(50) NOT NULL,
  CONSTRAINT uq_indicador_nombre UNIQUE (nombre_indicador)
);

CREATE TABLE observacion (
  id_territorio INT NOT NULL,
  anio SMALLINT NOT NULL,
  id_indicador INT NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_territorio, anio, id_indicador),
  CONSTRAINT fk_obs_territorio FOREIGN KEY (id_territorio) REFERENCES territorio(id_territorio) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_obs_periodo FOREIGN KEY (anio) REFERENCES periodo(anio) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_obs_indicador FOREIGN KEY (id_indicador) REFERENCES indicador(id_indicador) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_obs_valor CHECK (valor >= 0)
);

INSERT INTO periodo (anio) VALUES (2000), (2001), (2002), (2003), (2004), (2005), (2006), (2007), (2008), (2009), (2010), (2011), (2012), (2013), (2014), (2015), (2016), (2017), (2018), (2019), (2020), (2021), (2022), (2023), (2024), (2025), (2026);

INSERT INTO indicador (nombre_indicador, unidad_medida) VALUES ('Precio medio del alquiler de viviendas','EUR/mes');

-- TERRITORIOS: parent IDs are resolved after insertion using the parent name.
-- BINARY garantiza la comparación exacta de nombres, distinguiendo mayúsculas
-- y minúsculas (por ejemplo, el distrito Les Corts y el barrio les Corts).
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) VALUES ('Catalunya', 'comunidad_autonoma', NULL);
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Metropolità de Barcelona', 'area_metropolitana', id_territorio FROM territorio WHERE nombre_territorio = 'Catalunya' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Barcelona', 'municipio', id_territorio FROM territorio WHERE nombre_territorio = 'Metropolità de Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Ciutat Vella', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Raval', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Ciutat Vella' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Barri Gòtic', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Ciutat Vella' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Barceloneta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Ciutat Vella' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Pere, Santa Caterina i la Ribera', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Ciutat Vella' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Eixample', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Fort Pienc', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Sagrada Família', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Dreta de l''Eixample', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'l''Antiga Esquerra de l''Eixample', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Nova Esquerra de l''Eixample', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Antoni', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Eixample' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sants-Montjuïc', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Poble Sec - AEI Parc Montjuïc', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Marina del Prat Vermell - AEI Zona Franca', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Marina de Port', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Font de la Guatlla', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Hostafrancs', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Bordeta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sants - Badal', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sants', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sants-Montjuïc' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Les Corts', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'les Corts', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Les Corts' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Maternitat i Sant Ramon', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Les Corts' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Pedralbes', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Les Corts' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sarrià-Sant Gervasi', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Vallvidrera, el Tibidabo i les Planes', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sarrià', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'les Tres Torres', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Gervasi - la Bonanova', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Gervasi - Galvany', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Putxet i el Farró', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sarrià-Sant Gervasi' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Gràcia', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Vallcarca i els Penitents', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Gràcia' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Coll', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Gràcia' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Salut', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Gràcia' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Vila de Gràcia', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Gràcia' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Camp d''en Grassot i Gràcia Nova', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Gràcia' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Horta-Guinardó', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Baix Guinardó', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Can Baró', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Guinardó', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Font d''en Fargues', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Carmel', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Teixonera', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Genís dels Agudells', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Montbau', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Vall d''Hebron', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Clota', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Horta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Horta-Guinardó' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Nou Barris', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Vilapicina i la Torre Llobeta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Porta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Turó de la Peira', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Can Peguera', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Guineueta', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Canyelles', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'les Roquetes', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Verdun', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Prosperitat', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Trinitat Nova', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Torre Baró', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Ciutat Meridiana', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Vallbona', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Nou Barris' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Andreu (Distrito)', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Trinitat Vella', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Baró de Viver', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Bon Pastor', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Andreu (Barrio)', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Sagrera', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Congrés i els Indians', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Navas', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Andreu (Distrito)' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Martí', 'distrito', id_territorio FROM territorio WHERE nombre_territorio = 'Barcelona' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Camp de l''Arpa del Clot', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Clot', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Parc i la Llacuna del Poblenou', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Vila Olímpica del Poblenou', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Poblenou', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Diagonal Mar i el Front Marítim del Poblenou', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'el Besòs i el Maresme', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Provençals del Poblenou', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'Sant Martí de Provençals', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;
INSERT INTO territorio (nombre_territorio, tipo_territorio, id_padre) SELECT 'la Verneda i la Pau', 'barrio', id_territorio FROM territorio WHERE nombre_territorio = 'Sant Martí' LIMIT 1;

-- OBSERVACIONES: importación de valores disponibles; '-' se omite.
-- Cada INSERT localiza el territorio por su nombre exacto y el indicador por nombre.
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 552.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 602.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 645.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 677.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 650.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 614.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 599.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 571.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 542.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 539.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 557.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 595.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 654.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 698.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 735.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 734.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 724.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 779.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 835.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 844.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 860.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 869.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Catalunya' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 596.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 651.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 708.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 749.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 720.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 687.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 670.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 639.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 603.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 603.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 634.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 685.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 753.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 800.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 844.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 842.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 821.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 889.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 960.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 979.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 996.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1007.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Metropolità de Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 408.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 466.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 519.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 550.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 584.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 636.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 695.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 766.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 813.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 792.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 761.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 752.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 720.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 681.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 688.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 734.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 801.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 877.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 929.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 978.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 964.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 918.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1026.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1136.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1147.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1134.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1139.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Barcelona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 325.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 350.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 412.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 443.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 469.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 539.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 597.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 660.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 729.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 715.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 678.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 663.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 644.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 618.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 639.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 675.74 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 739.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 828.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 914.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 945.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 913.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 846.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1008.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1079.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1063.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1018.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 998.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 577.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 625.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 667.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 748.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 821.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 850.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 833.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 768.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 911.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 959.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 975.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 957.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 906.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Raval' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 749.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 786.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 868.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 973.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1024.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1097.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1035.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 947.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1133.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1265.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1195.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1172.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1183.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Barri Gòtic' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 563.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 602.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 667.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 745.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 899.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 895.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 867.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 827.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 944.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 991.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1015.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 881.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 838.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Barceloneta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 685.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 723.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 807.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 916.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 972.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 996.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 954.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 888.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1070.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1138.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1130.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1081.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1118.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Pere, Santa Caterina i la Ribera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 436.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 515.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 564.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 595.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 635.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 703.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 750.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 831.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 891.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 862.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 833.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 821.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 800.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 763.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 776.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 831.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 917.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 990.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1038.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1093.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1075.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1007.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1140.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1274.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1285.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1283.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1269.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 723.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 768.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 823.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 900.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 950.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1012.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1003.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 941.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1071.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1179.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1178.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1134.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1094.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Fort Pienc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 680.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 713.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 775.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 876.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 909.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 960.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 942.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 901.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1019.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1115.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1139.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1106.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1090.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrada Família' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 945.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1012.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1138.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1195.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1254.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1307.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1273.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1189.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1389.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1578.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1572.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1596.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1592.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Dreta de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 843.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 911.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 979.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1060.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1113.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1162.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1155.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1073.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1201.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1352.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1367.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1389.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1353.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'l''Antiga Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 732.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 783.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 870.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 943.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 987.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1053.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1034.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 963.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1069.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1177.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1217.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1203.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1206.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Nova Esquerra de l''Eixample' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 711.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 765.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 842.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 900.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 934.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 994.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 971.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 928.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1037.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1134.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1131.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1118.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1123.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Antoni' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 336.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 381.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 437.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 453.74 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 498.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 558.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 620.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 668.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 725.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 698.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 671.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 671.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 633.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 596.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 598.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 624.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 678.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 763.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 803.74 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 841.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 846.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 799.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 916.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1032.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 981.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1001.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1001.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants-Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 582.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 612.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 669.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 749.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 801.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 837.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 827.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 780.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 881.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 937.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 959.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 942.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 952.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poble Sec - AEI Parc Montjuïc' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 450.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 404.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 356.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 374.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 430.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1456.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1451.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 751.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1389.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1391.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina del Prat Vermell - AEI Zona Franca' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 527.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 542.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 544.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 691.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 751.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 766.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 787.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 743.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 723.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 885.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 843.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 885.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 943.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Marina de Port' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 644.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 695.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 737.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 811.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 839.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 865.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 859.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 826.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 928.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1047.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1021.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1043.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1032.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font de la Guatlla' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 593.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 624.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 687.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 747.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 796.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 830.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 852.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 789.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 879.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 967.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 961.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 959.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 951.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Hostafrancs' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 611.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 638.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 678.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 789.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 801.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 851.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 861.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 832.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1124.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1326.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1186.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1185.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1152.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Bordeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 597.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 626.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 691.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 759.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 784.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 851.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 845.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 793.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 881.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 981.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 966.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 942.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 965.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants - Badal' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 624.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 653.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 711.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 787.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 826.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 877.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 874.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 828.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 906.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1006.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1008.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 994.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1016.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sants' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 567.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 627.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 621.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 667.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 705.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 742.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 829.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 955.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 990.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 933.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 908.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 891.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 867.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 826.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 853.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 925.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 985.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1052.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1089.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1156.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1112.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1054.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1185.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1294.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1344.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1334.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1271.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 782.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 856.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 939.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1002.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1039.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1097.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1060.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1015.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1129.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1215.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1276.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1298.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1214.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Corts' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 760.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 756.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 847.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 925.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 973.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1009.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 992.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 935.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1068.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1190.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1166.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1160.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1156.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Maternitat i Sant Ramon' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1473.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1729.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1661.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1785.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1739.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1860.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1718.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1699.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1813.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1952.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 2088.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1947.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1900.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Pedralbes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 631.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 659.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 742.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 762.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 823.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 863.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 917.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 1014.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 1081.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 1029.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 998.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 1017.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 984.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 935.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 978.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1051.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1144.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1227.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1268.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1316.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1305.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1246.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1384.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1550.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1615.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1603.74 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1595.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià-Sant Gervasi' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1134.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1006.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1153.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1220.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 937.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1205.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1233.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1236.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1107.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1255.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1487.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1613.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1638.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallvidrera, el Tibidabo i les Planes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1041.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1109.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1187.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1353.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1368.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1375.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1366.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1303.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1431.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1528.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1563.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1666.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1591.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sarrià' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1323.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1385.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1515.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1634.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1599.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1657.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1696.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1544.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1807.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1955.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 2067.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 2013.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 2084.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Tres Torres' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 942.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1046.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1125.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1236.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1285.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1304.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1301.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1216.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1360.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1507.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1667.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1658.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1544.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - la Bonanova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1047.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1156.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1241.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1311.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1347.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1397.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1362.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1355.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1487.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1696.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1739.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1731.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1778.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Gervasi - Galvany' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 760.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 799.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 876.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 930.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 995.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1086.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1056.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1003.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1115.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1255.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1279.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1201.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1232.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Putxet i el Farró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 370.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 425.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 495.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 507.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 548.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 620.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 668.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 741.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 792.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 762.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 738.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 737.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 706.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 659.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 673.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 721.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 787.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 856.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 904.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 957.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 950.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 896.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 999.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1117.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1151.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1082.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1088.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 665.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 735.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 787.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 910.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 925.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 972.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 982.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 941.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1006.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1137.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1181.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1088.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1150.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallcarca i els Penitents' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 555.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 557.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 620.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 724.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 740.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 801.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 809.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 762.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 808.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 922.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 903.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 905.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 991.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Coll' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 668.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 705.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 773.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 799.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 877.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 918.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 967.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 888.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 955.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1090.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1151.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1068.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1082.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Salut' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 681.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 733.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 799.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 860.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 915.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 962.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 953.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 900.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1017.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1125.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1155.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1089.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1085.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila de Gràcia' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 683.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 725.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 803.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 864.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 908.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 983.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 953.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 892.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1007.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1138.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1177.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1105.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1092.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp d''en Grassot i Gràcia Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 334.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 390.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 421.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 463.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 501.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 552.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 630.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 660.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 718.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 689.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 652.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 636.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 605.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 566.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 563.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 586.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 640.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 706.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 746.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 794.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 799.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 768.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 819.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 915.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 924.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 909.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 925.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta-Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 620.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 642.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 701.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 770.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 828.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 882.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 890.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 823.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 911.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1028.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1017.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 997.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1008.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Baix Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 542.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 553.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 636.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 686.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 738.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 769.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 787.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 756.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 806.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 890.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 917.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 846.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 891.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 581.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 612.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 666.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 736.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 771.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 819.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 822.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 809.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 847.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 964.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 974.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 958.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 955.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Guinardó' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 712.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 723.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 717.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 817.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 828.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 885.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 918.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 815.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 873.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1057.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1088.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1044.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1120.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Font d''en Fargues' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 495.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 510.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 554.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 603.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 644.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 685.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 687.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 674.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 727.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 776.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 796.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 781.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 803.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Carmel' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 486.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 519.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 578.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 648.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 701.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 738.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 718.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 714.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 779.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 847.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 864.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 865.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 851.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Teixonera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 553.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 551.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 609.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 674.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 656.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 738.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 730.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 704.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 734.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 822.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 798.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 831.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 824.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Genís dels Agudells' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 552.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 630.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 644.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 724.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 737.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 793.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 784.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 740.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 793.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 896.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 905.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 869.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 887.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Montbau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 699.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 696.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 767.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 828.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 859.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 864.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 890.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 861.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 906.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 945.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1030.87 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 976.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1025.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vall d''Hebron' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 480.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 350.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 538.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 651.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 500.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 666.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 589.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 742.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 829.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1036.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1073.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Clota' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 567.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 579.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 630.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 698.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 747.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 782.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 785.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 749.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 801.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 895.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 915.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 896.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 916.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Horta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 330.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 369.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 426.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 438.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 472.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 513.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 582.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 632.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 676.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 653.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 621.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 609.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 551.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 513.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 499.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 518.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 561.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 625.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 674.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 704.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 705.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 684.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 730.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 796.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 796.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 796.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 807.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Nou Barris' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 568.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 586.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 638.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 714.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 744.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 781.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 797.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 761.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 826.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 906.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 910.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 887.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 898.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vilapicina i la Torre Llobeta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 529.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 555.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 603.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 662.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 706.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 751.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 724.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 714.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 758.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 836.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 836.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 818.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 875.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Porta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 473.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 504.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 552.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 615.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 676.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 697.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 695.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 682.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 725.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 765.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 788.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 757.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 735.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Turó de la Peira' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 221.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 211.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 253.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 417.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 439.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 419.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 365.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 545.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 395.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 378.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Can Peguera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 614.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 562.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 623.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 650.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 714.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 744.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 737.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 678.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 760.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 843.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 879.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 902.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 854.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Guineueta' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 536.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 563.96 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 625.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 680.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 716.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 752.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 769.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 746.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 803.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 832.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 873.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 791.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 854.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Canyelles' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 450.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 463.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 489.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 533.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 602.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 621.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 638.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 622.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 666.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 734.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 721.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 701.28 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 713.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'les Roquetes' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 487.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 470.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 533.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 591.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 630.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 663.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 660.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 648.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 645.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 753.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 716.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 759.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 735.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Verdun' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 504.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 530.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 562.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 628.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 665.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 684.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 700.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 676.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 725.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 784.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 791.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 818.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 845.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Prosperitat' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 434.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 448.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 431.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 541.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 580.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 606.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 586.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 594.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 628.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 657.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 712.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 636.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 663.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Nova' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 334.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 404.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 412.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 425.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 512.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 471.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 525.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 538.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 553.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 494.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 452.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 577.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 823.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Torre Baró' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 372.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 396.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 402.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 435.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 506.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 562.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 539.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 526.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 563.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 611.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 628.19 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 600.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 576.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Ciutat Meridiana' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 281.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 415.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 469.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 476.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 613.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 581.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 584.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 517.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 616.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 697.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Vallbona' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 339.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 385.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 431.44 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 462.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 508.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 569.40 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 601.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 675.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 723.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 707.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 672.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 658.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 626.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 578.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 575.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 611.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 644.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 705.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 762.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 796.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 797.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 764.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 829.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 910.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 919.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 903.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 927.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 422.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 441.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 479.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 497.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 586.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 602.88 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 639.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 606.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 646.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 714.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 658.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 681.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 766.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Trinitat Vella' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 241.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 287.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 216.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 458.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 621.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 486.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 581.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 556.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 615.98 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 699.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 524.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 554.77 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Baró de Viver' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 496.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 537.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 540.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 627.45 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 682.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 685.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 726.61 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 683.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 741.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 724.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 713.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 765.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 725.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Bon Pastor' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 576.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 613.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 658.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 733.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 764.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 805.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 810.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 766.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 821.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 910.97 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 923.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 880.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 919.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Barrio)' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 607.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 636.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 665.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 667.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 780.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 817.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 783.89 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 768.29 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 865.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 968.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1009.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 979.20 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 985.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Sagrera' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 583.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 610.94 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 649.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 730.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 774.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 793.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 804.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 775.46 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 830.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 924.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 945.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 898.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 937.79 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Congrés i els Indians' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 623.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 672.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 714.10 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 777.64 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 813.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 853.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 864.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 820.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 884.21 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 974.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 989.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 980.13 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 998.69 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Navas' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2000, i.id_indicador, 341.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2001, i.id_indicador, 398.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2002, i.id_indicador, 467.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2003, i.id_indicador, 484.76 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2004, i.id_indicador, 531.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2005, i.id_indicador, 605.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2006, i.id_indicador, 682.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2007, i.id_indicador, 730.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2008, i.id_indicador, 770.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2009, i.id_indicador, 738.26 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2010, i.id_indicador, 727.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2011, i.id_indicador, 705.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2012, i.id_indicador, 673.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2013, i.id_indicador, 637.39 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 640.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 700.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 771.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 842.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 884.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 941.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 929.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 888.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1000.16 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1101.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1098.81 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1094.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1128.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 598.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 644.01 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 697.99 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 778.14 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 818.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 856.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 862.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 820.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 894.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 982.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 982.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 981.62 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1018.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Camp de l''Arpa del Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 624.84 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 651.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 695.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 767.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 808.90 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 856.54 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 872.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 825.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 904.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1031.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1032.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 966.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 990.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Clot' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 693.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 748.85 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 823.60 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 893.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 995.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1014.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 974.32 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 972.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1150.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1238.07 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1161.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1258.12 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1238.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Parc i la Llacuna del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 1003.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1104.48 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1184.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1259.70 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1284.43 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1361.65 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1376.59 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1308.93 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1426.27 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1495.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1677.17 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1613.36 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1644.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Vila Olímpica del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 654.35 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 735.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 794.11 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 900.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 961.73 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1004.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1002.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 945.86 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1079.91 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1172.83 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1211.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1189.53 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1254.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 892.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 1059.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 1124.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 1092.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 1085.34 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 1372.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 1171.57 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 1045.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1247.50 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1325.18 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1359.49 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1731.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1500.51 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Diagonal Mar i el Front Marítim del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 477.06 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 506.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 541.25 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 613.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 685.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 738.08 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 752.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 710.37 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 778.67 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 779.66 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 841.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 756.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 867.04 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'el Besòs i el Maresme' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 639.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 661.38 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 839.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 932.02 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 948.80 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 982.03 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 957.52 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 949.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 1024.30 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1161.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1141.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1114.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 1161.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Provençals del Poblenou' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 633.78 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 673.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 700.75 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 765.22 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 792.68 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 837.58 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 832.09 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 806.82 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 987.55 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 974.24 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 998.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 1011.05 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 990.95 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'Sant Martí de Provençals' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2014, i.id_indicador, 565.47 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2015, i.id_indicador, 610.72 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2016, i.id_indicador, 605.56 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2017, i.id_indicador, 688.63 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2018, i.id_indicador, 740.92 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2019, i.id_indicador, 778.41 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2020, i.id_indicador, 771.15 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2021, i.id_indicador, 743.71 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2022, i.id_indicador, 931.42 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2023, i.id_indicador, 1064.23 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2024, i.id_indicador, 1001.31 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2025, i.id_indicador, 924.00 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';
INSERT INTO observacion (id_territorio, anio, id_indicador, valor) SELECT t.id_territorio, 2026, i.id_indicador, 993.33 FROM territorio t CROSS JOIN indicador i WHERE BINARY t.nombre_territorio = BINARY 'la Verneda i la Pau' AND i.nombre_indicador = 'Precio medio del alquiler de viviendas';

-- Comprobaciones
SELECT COUNT(*) AS total_territorios FROM territorio;
SELECT COUNT(*) AS total_observaciones FROM observacion;

-- Ejemplo: evolución anual del precio medio de alquiler en Barcelona
SELECT p.anio, o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t ON t.id_territorio = o.id_territorio
JOIN periodo p ON p.anio = o.anio
JOIN indicador i ON i.id_indicador = o.id_indicador
WHERE BINARY t.nombre_territorio = BINARY 'Barcelona'
  AND i.nombre_indicador = 'Precio medio del alquiler de viviendas'
ORDER BY p.anio;

-- ============================================================================
-- CONSULTAS ADICIONALES DE VALIDACIÓN Y ANÁLISIS
-- Ejecutar estas consultas después de crear las tablas y cargar los datos.
-- ============================================================================

-- 1. Comprobar cuántos territorios hay de cada tipo.
SELECT tipo_territorio, COUNT(*) AS cantidad
FROM territorio
GROUP BY tipo_territorio
ORDER BY tipo_territorio;

-- 2. Comprobar la cantidad de observaciones por año.
SELECT anio, COUNT(*) AS cantidad_observaciones
FROM observacion
GROUP BY anio
ORDER BY anio;

-- 3. Comparar el precio medio entre los distritos de Barcelona para 2026.
SELECT t.nombre_territorio AS distrito, o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t ON t.id_territorio = o.id_territorio
JOIN indicador i ON i.id_indicador = o.id_indicador
WHERE t.tipo_territorio = 'distrito'
  AND i.nombre_indicador = 'Precio medio del alquiler de viviendas'
  AND o.anio = 2026
ORDER BY o.valor DESC;

-- 4. Evolución anual del precio medio en el distrito de Sant Andreu.
SELECT p.anio, o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t ON t.id_territorio = o.id_territorio
JOIN periodo p ON p.anio = o.anio
JOIN indicador i ON i.id_indicador = o.id_indicador
WHERE BINARY t.nombre_territorio = BINARY 'Sant Andreu (Distrito)'
  AND i.nombre_indicador = 'Precio medio del alquiler de viviendas'
ORDER BY p.anio;

-- 5. Calcular la variación porcentual respecto al año anterior para Barcelona.
SELECT
    p.anio,
    o.valor AS precio_actual,
    LAG(o.valor) OVER (ORDER BY p.anio) AS precio_anterior,
    ROUND(
        (o.valor - LAG(o.valor) OVER (ORDER BY p.anio)) /
        LAG(o.valor) OVER (ORDER BY p.anio) * 100, 2
    ) AS variacion_porcentual
FROM observacion o
JOIN territorio t ON t.id_territorio = o.id_territorio
JOIN periodo p ON p.anio = o.anio
JOIN indicador i ON i.id_indicador = o.id_indicador
WHERE BINARY t.nombre_territorio = BINARY 'Barcelona'
  AND i.nombre_indicador = 'Precio medio del alquiler de viviendas'
ORDER BY p.anio;

-- 6. Detectar posibles observaciones duplicadas (el resultado esperado es vacío).
SELECT id_territorio, anio, id_indicador, COUNT(*) AS repeticiones
FROM observacion
GROUP BY id_territorio, anio, id_indicador
HAVING COUNT(*) > 1;

USE alquiler_barcelona;

SELECT COUNT(*) AS total_observaciones
FROM observacion;

USE alquiler_barcelona;

SELECT *
FROM observacion
LIMIT 10;

SELECT *
FROM territorio
WHERE id_territorio = 1;

SELECT
    t.nombre_territorio,
    p.anio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.id_territorio = 1
ORDER BY p.anio;

SELECT
    t.nombre_territorio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN indicador i
    ON o.id_indicador = i.id_indicador
WHERE t.tipo_territorio = 'distrito'
    AND o.anio = 2026
    AND i.nombre_indicador = 'Precio medio del alquiler de viviendas'
ORDER BY o.valor DESC;

SELECT
    t.nombre_territorio,
    p.anio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.nombre_territorio = 'Sant Andreu (Distrito)'
ORDER BY p.anio;

SELECT
    AVG(o.valor) AS alquiler_promedio,
    MIN(o.valor) AS alquiler_minimo,
    MAX(o.valor) AS alquiler_maximo,
    COUNT(*) AS total_registros
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.nombre_territorio = 'Sant Andreu (Distrito)';

SELECT
    id_territorio,
    nombre_territorio,
    tipo_territorio,
    id_padre
FROM territorio
WHERE nombre_territorio LIKE '%Sant Antoni%'
   OR nombre_territorio LIKE '%Raval%';

   SELECT
    t.nombre_territorio,
    p.anio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.id_territorio IN (5, 15)
    AND p.anio >= 2000
ORDER BY
    p.anio,
    t.nombre_territorio;

     SELECT
    p.anio,
    MAX(CASE
        WHEN t.nombre_territorio = 'el Raval'
        THEN o.valor
    END) AS el_raval,
    MAX(CASE
        WHEN t.nombre_territorio = 'Sant Antoni'
        THEN o.valor
    END) AS sant_antoni
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.id_territorio IN (5, 15)
GROUP BY p.anio
ORDER BY p.anio;

SELECT
    t.nombre_territorio,
    p.anio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.nombre_territorio IN (
    'el Poblenou',
    'la Trinitat Vella',
    'Diagonal Mar i el Front Marítim del Poblenou',
    'Eixample',
    'Sants',
    'la Sagrera',
    'Gràcia',
    'Sant Andreu (Distrito)',
    'Catalunya',
    'la Sagrada Família',
    'Sant Andreu (Barrio)',
    'el Clot',
    'Sant Antoni',
    'el Barri Gòtic',
    'el Raval',
    'Ciutat Vella',
    'la Barceloneta'
)
AND p.anio BETWEEN 2016 AND 2026
ORDER BY
    t.nombre_territorio,
    p.anio;

SELECT
    t.nombre_territorio,

    MAX(CASE
        WHEN p.anio = 2016 THEN o.valor
    END) AS precio_2016,

    MAX(CASE
        WHEN p.anio = 2026 THEN o.valor
    END) AS precio_2026,

    ROUND(
        MAX(CASE WHEN p.anio = 2026 THEN o.valor END) -
        MAX(CASE WHEN p.anio = 2016 THEN o.valor END),
        2
    ) AS crecimiento_euros,

    ROUND(
        (
            MAX(CASE WHEN p.anio = 2026 THEN o.valor END) -
            MAX(CASE WHEN p.anio = 2016 THEN o.valor END)
        ) /
        MAX(CASE WHEN p.anio = 2016 THEN o.valor END) * 100,
        2
    ) AS crecimiento_porcentaje

FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio

WHERE t.nombre_territorio IN (
    'el Poblenou',
    'la Trinitat Vella',
    'Diagonal Mar i el Front Marítim del Poblenou',
    'Eixample',
    'Sants',
    'la Sagrera',
    'Gràcia',
    'Sant Andreu (Distrito)',
    'Catalunya',
    'la Sagrada Família',
    'Sant Andreu (Barrio)',
    'el Clot',
    'Sant Antoni',
    'el Barri Gòtic',
    'el Raval',
    'Ciutat Vella',
    'la Barceloneta'
)

GROUP BY t.nombre_territorio
ORDER BY crecimiento_porcentaje DESC;


SELECT
    t.nombre_territorio,
    p.anio,
    o.valor AS precio_medio_eur_mes
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN periodo p
    ON o.anio = p.anio
WHERE t.nombre_territorio IN (
    'el Poblenou',
    'la Trinitat Vella',
    'Diagonal Mar i el Front Marítim del Poblenou',
    'Eixample',
    'Sants',
    'la Sagrera',
    'Gràcia',
    'Sant Andreu (Distrito)',
    'Catalunya',
    'la Sagrada Família',
    'Sant Andreu (Barrio)',
    'el Clot',
    'Sant Antoni',
    'el Barri Gòtic',
    'el Raval',
    'Ciutat Vella',
    'la Barceloneta'
)
AND p.anio BETWEEN 2016 AND 2026
ORDER BY
    MAX(CASE WHEN p.anio = 2026 THEN o.valor END)
        OVER (PARTITION BY t.nombre_territorio) DESC,
    t.nombre_territorio,
    p.anio;

    SELECT
    t.nombre_territorio,

    MAX(CASE WHEN p.anio = 2016 THEN o.valor END) AS `2016`,
    MAX(CASE WHEN p.anio = 2017 THEN o.valor END) AS `2017`,
    MAX(CASE WHEN p.anio = 2018 THEN o.valor END) AS `2018`,
    MAX(CASE WHEN p.anio = 2019 THEN o.valor END) AS `2019`,
    MAX(CASE WHEN p.anio = 2020 THEN o.valor END) AS `2020`,
    MAX(CASE WHEN p.anio = 2021 THEN o.valor END) AS `2021`,
    MAX(CASE WHEN p.anio = 2022 THEN o.valor END) AS `2022`,
    MAX(CASE WHEN p.anio = 2023 THEN o.valor END) AS `2023`,
    MAX(CASE WHEN p.anio = 2024 THEN o.valor END) AS `2024`,
    MAX(CASE WHEN p.anio = 2025 THEN o.valor END) AS `2025`,
    MAX(CASE WHEN p.anio = 2026 THEN o.valor END) AS `2026`,

    ROUND(
        (
            MAX(CASE WHEN p.anio = 2026 THEN o.valor END) -
            MAX(CASE WHEN p.anio = 2016 THEN o.valor END)
        ) /
        NULLIF(MAX(CASE WHEN p.anio = 2016 THEN o.valor END), 0)
        * 100,
        2
    ) AS crecimiento_porcentaje

FROM observacion o

JOIN territorio t
    ON o.id_territorio = t.id_territorio

JOIN periodo p
    ON o.anio = p.anio

WHERE t.nombre_territorio IN (
    'el Poblenou',
    'la Trinitat Vella',
    'Diagonal Mar i el Front Marítim del Poblenou',
    'Eixample',
    'Sants',
    'la Sagrera',
    'Gràcia',
    'Sant Andreu (Distrito)',
    'Catalunya',
    'la Sagrada Família',
    'Sant Andreu (Barrio)',
    'el Clot',
    'Sant Antoni',
    'el Barri Gòtic',
    'el Raval',
    'Ciutat Vella',
    'la Barceloneta'
)

GROUP BY t.nombre_territorio

ORDER BY `2026` DESC;



-- CONSULTAS ANALÍTICAS
-- =====================================================
-- CONSULTA 1. Ranking de barrios según el precio medio
-- del alquiler en 2026.
--
-- Objetivo:
-- Identificar los barrios con el precio medio del alquiler
-- más alto y más bajo en el año 2026.
-- =====================================================


SELECT
    t.nombre_territorio AS barrio,
    o.valor AS precio_medio_eur
FROM observacion o
INNER JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.anio = 2026
    AND o.id_indicador = 1
ORDER BY o.valor DESC;


-- =====================================================
-- CONSULTA 2. Comparación del precio del alquiler
-- entre 2025 y 2026 por barrio.
--
-- Objetivo:
-- Comparar el precio medio del alquiler de cada barrio
-- entre los años 2025 y 2026 y calcular la diferencia
-- en euros, identificando los barrios con mayores
-- incrementos y disminuciones.
-- =====================================================
USE alquiler_barcelona;
SELECT
    t.nombre_territorio AS barrio,
    MAX(CASE WHEN o.anio = 2025 THEN o.valor END) AS precio_2025,
    MAX(CASE WHEN o.anio = 2026 THEN o.valor END) AS precio_2026,
    ROUND(
        MAX(CASE WHEN o.anio = 2026 THEN o.valor END) -
        MAX(CASE WHEN o.anio = 2025 THEN o.valor END),
        2
    ) AS diferencia_eur
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.id_indicador = 1
    AND o.anio IN (2025, 2026)
GROUP BY t.id_territorio, t.nombre_territorio
HAVING COUNT(DISTINCT o.anio) = 2
ORDER BY diferencia_eur DESC;


-- =====================================================
-- CONSULTA 3. Evolución del precio del alquiler
-- por barrio entre 2017 y 2026.
--
-- Objetivo:
-- Mostrar la evolución anual del precio medio del alquiler
-- en cada barrio durante el periodo 2017-2026.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    o.anio,
    o.valor AS precio_medio_eur
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.id_indicador = 1
    AND o.anio BETWEEN 2017 AND 2026
ORDER BY t.nombre_territorio, o.anio;


-- =====================================================
-- CONSULTA 4. Variación absoluta y porcentual del alquiler
-- entre 2017 y 2025 por barrio.
--
-- Objetivo:
-- Calcular la diferencia en euros y en porcentaje
-- entre los precios medios de 2017 y 2025.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    MAX(CASE WHEN o.anio = 2017 THEN o.valor END) AS precio_2017,
    MAX(CASE WHEN o.anio = 2025 THEN o.valor END) AS precio_2025,
    ROUND(
        MAX(CASE WHEN o.anio = 2025 THEN o.valor END) -
        MAX(CASE WHEN o.anio = 2017 THEN o.valor END),
        2
    ) AS variacion_eur,
    ROUND(
        (
            MAX(CASE WHEN o.anio = 2025 THEN o.valor END) -
            MAX(CASE WHEN o.anio = 2017 THEN o.valor END)
        ) /
        MAX(CASE WHEN o.anio = 2017 THEN o.valor END) * 100,
        2
    ) AS variacion_porcentual
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.id_indicador = 1
    AND o.anio IN (2017, 2025)
GROUP BY t.id_territorio, t.nombre_territorio
HAVING COUNT(DISTINCT o.anio) = 2
ORDER BY variacion_porcentual DESC;


-- =====================================================
-- CONSULTA 5. Ranking de los 10 barrios con mayor
-- crecimiento porcentual del alquiler entre 2017 y 2025.
--
-- Objetivo:
-- Identificar los diez barrios con mayor incremento
-- porcentual del precio medio del alquiler.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    MAX(CASE WHEN o.anio = 2017 THEN o.valor END) AS precio_2017,
    MAX(CASE WHEN o.anio = 2025 THEN o.valor END) AS precio_2025,
    ROUND(
        (
            MAX(CASE WHEN o.anio = 2025 THEN o.valor END) -
            MAX(CASE WHEN o.anio = 2017 THEN o.valor END)
        ) /
        MAX(CASE WHEN o.anio = 2017 THEN o.valor END) * 100,
        2
    ) AS crecimiento_porcentual
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.id_indicador = 1
    AND o.anio IN (2017, 2025)
GROUP BY t.id_territorio, t.nombre_territorio
HAVING COUNT(DISTINCT o.anio) = 2
ORDER BY crecimiento_porcentual DESC
LIMIT 10;


-- =====================================================
-- CONSULTA 6. Comparación del precio del alquiler
-- entre barrios y sus distritos en 2025.
--
-- Objetivo:
-- Comparar el precio medio del alquiler de cada barrio
-- con el precio medio de su distrito correspondiente.
-- =====================================================

SELECT
    b.nombre_territorio AS barrio,
    d.nombre_territorio AS distrito,
    ob.valor AS precio_barrio,
    od.valor AS precio_distrito,
    ROUND(ob.valor - od.valor, 2) AS diferencia_eur
FROM territorio b
JOIN territorio d
    ON b.id_padre = d.id_territorio
JOIN observacion ob
    ON b.id_territorio = ob.id_territorio
JOIN observacion od
    ON d.id_territorio = od.id_territorio
WHERE b.tipo_territorio = 'barrio'
    AND d.tipo_territorio = 'distrito'
    AND ob.anio = 2025
    AND od.anio = 2025
    AND ob.id_indicador = 1
    AND od.id_indicador = 1
ORDER BY d.nombre_territorio, diferencia_eur DESC;


-- =====================================================
-- CONSULTA 7. Comparación del precio del alquiler
-- de cada barrio con el municipio de Barcelona en 2025.
--
-- Objetivo:
-- Comparar el precio medio del alquiler de cada barrio
-- con el precio medio registrado en Barcelona.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    o.valor AS precio_barrio,
    b.valor AS precio_barcelona,
    ROUND(o.valor - b.valor, 2) AS diferencia_eur,
    ROUND(
        (o.valor - b.valor) / b.valor * 100,
        2
    ) AS diferencia_porcentual
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
JOIN observacion b
    ON b.anio = o.anio
    AND b.id_indicador = o.id_indicador
JOIN territorio tb
    ON b.id_territorio = tb.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND BINARY tb.nombre_territorio = BINARY 'Barcelona'
    AND o.anio = 2025
    AND b.anio = 2025
    AND o.id_indicador = 1
    AND b.id_indicador = 1
ORDER BY diferencia_eur DESC;


-- =====================================================
-- CONSULTA 8. Variación anual del precio del alquiler
-- por barrio mediante la función LAG().
--
-- Objetivo:
-- Calcular la diferencia en euros y en porcentaje
-- respecto al año anterior para cada barrio.
-- =====================================================

SELECT
    barrio,
    anio,
    precio_actual,
    precio_anterior,
    ROUND(precio_actual - precio_anterior, 2) AS variacion_eur,
    ROUND(
        (precio_actual - precio_anterior) /
        precio_anterior * 100,
        2
    ) AS variacion_porcentual
FROM (
    SELECT
        t.nombre_territorio AS barrio,
        o.anio,
        o.valor AS precio_actual,
        LAG(o.valor) OVER (
            PARTITION BY t.id_territorio
            ORDER BY o.anio
        ) AS precio_anterior
    FROM observacion o
    JOIN territorio t
        ON o.id_territorio = t.id_territorio
    WHERE t.tipo_territorio = 'barrio'
        AND o.id_indicador = 1
        AND o.anio BETWEEN 2017 AND 2025
) AS datos
ORDER BY barrio, anio;


-- =====================================================
-- CONSULTA 9. Barrios por encima y por debajo
-- del precio medio de Barcelona en 2025.
--
-- Objetivo:
-- Identificar qué barrios tienen un precio medio
-- superior o inferior al precio de Barcelona.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    o.valor AS precio_barrio,
    (
        SELECT ob.valor
        FROM observacion ob
        JOIN territorio tb
            ON ob.id_territorio = tb.id_territorio
        WHERE BINARY tb.nombre_territorio = BINARY 'Barcelona'
            AND ob.anio = 2025
            AND ob.id_indicador = 1
    ) AS precio_barcelona,
    CASE
        WHEN o.valor > (
            SELECT ob.valor
            FROM observacion ob
            JOIN territorio tb
                ON ob.id_territorio = tb.id_territorio
            WHERE BINARY tb.nombre_territorio = BINARY 'Barcelona'
                AND ob.anio = 2025
                AND ob.id_indicador = 1
        ) THEN 'Por encima'
        WHEN o.valor < (
            SELECT ob.valor
            FROM observacion ob
            JOIN territorio tb
                ON ob.id_territorio = tb.id_territorio
            WHERE BINARY tb.nombre_territorio = BINARY 'Barcelona'
                AND ob.anio = 2025
                AND ob.id_indicador = 1
        ) THEN 'Por debajo'
        ELSE 'Igual'
    END AS comparacion
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.anio = 2025
    AND o.id_indicador = 1
ORDER BY o.valor DESC;


-- =====================================================
-- CONSULTA 10. Estadísticas generales del precio
-- del alquiler por barrio entre 2017 y 2025.
--
-- Objetivo:
-- Calcular el precio medio, mínimo, máximo y número
-- de observaciones disponibles para cada barrio.
-- =====================================================

SELECT
    t.nombre_territorio AS barrio,
    ROUND(AVG(o.valor), 2) AS precio_medio_periodo,
    MIN(o.valor) AS precio_minimo,
    MAX(o.valor) AS precio_maximo,
    COUNT(*) AS numero_observaciones
FROM observacion o
JOIN territorio t
    ON o.id_territorio = t.id_territorio
WHERE t.tipo_territorio = 'barrio'
    AND o.id_indicador = 1
    AND o.anio BETWEEN 2017 AND 2025
GROUP BY t.id_territorio, t.nombre_territorio
ORDER BY precio_medio_periodo DESC;


