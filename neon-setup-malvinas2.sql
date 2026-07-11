-- ============================================
-- MALVINAS 2.0 - NUEVA FARMACIA BADRA
-- Pegar TODO esto en el SQL Editor de Neon y Run.
-- Crea las tablas y carga las 65 tintas + catálogos.
-- ============================================

CREATE TABLE IF NOT EXISTS tintas (
  id serial PRIMARY KEY,
  nombre text NOT NULL,
  keywords text NOT NULL DEFAULT '',
  concentracion real NOT NULL DEFAULT 0.5,
  ip real NOT NULL DEFAULT 1,
  a_manopla boolean NOT NULL DEFAULT false,
  ubicacion text NOT NULL DEFAULT 'cuerpo',
  excipientes jsonb NOT NULL DEFAULT '[]',
  parametros jsonb DEFAULT NULL,
  alerta text NOT NULL DEFAULT '',
  poe text NOT NULL DEFAULT '',
  activo boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS registros (
  id serial PRIMARY KEY,
  estado text NOT NULL DEFAULT 'en_proceso',
  grupo_paciente text NOT NULL DEFAULT '',
  titulo_formula text NOT NULL DEFAULT '',
  paciente text NOT NULL DEFAULT '',
  dni text NOT NULL DEFAULT '',
  medico text NOT NULL DEFAULT '',
  matricula text NOT NULL DEFAULT '',
  fecha_receta text NOT NULL DEFAULT '',
  nro_receta text NOT NULL DEFAULT '',
  diagnostico text NOT NULL DEFAULT '',
  indicacion text NOT NULL DEFAULT '',
  formula jsonb NOT NULL DEFAULT '[]',
  capsulas_por_toma integer NOT NULL DEFAULT 1,
  capsulas_por_toma_manual boolean NOT NULL DEFAULT false,
  excipientes jsonb NOT NULL DEFAULT '[]',
  dias integer,
  capsulas_totales integer,
  capsulas_por_envase integer,
  envases integer,
  tipo_envase text NOT NULL DEFAULT 'Envase plástico color caramelo',
  producto text NOT NULL DEFAULT 'CÁPSULAS MULTICAPA DE MANUFACTURA ADITIVA',
  masa_volumen text NOT NULL DEFAULT 'CÁPSULAS 00 (1 ML)',
  lote_prefijo text NOT NULL DEFAULT 'PT001',
  lote_numero integer,
  capas jsonb NOT NULL DEFAULT '[]',
  proceso jsonb NOT NULL DEFAULT '{"temperatura":"70","tiempoMezclado":"-","tiempoReposo":"5","otros":"-"}',
  controles jsonb NOT NULL DEFAULT '{"peso":true,"visual":true,"otroControl":"","vestimenta":true,"higiene":true}',
  aprobadas integer,
  rechazadas integer NOT NULL DEFAULT 0,
  fecha_hora_inicio text NOT NULL DEFAULT '',
  fecha_hora_fin text NOT NULL DEFAULT '',
  operador text NOT NULL DEFAULT '',
  supervisor text NOT NULL DEFAULT 'DT: Farm. Gonzalo A. Azategui MP 8288',
  fecha_elab text NOT NULL DEFAULT '',
  fecha_vto text NOT NULL DEFAULT '',
  fotos jsonb NOT NULL DEFAULT '[]',
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS registros_pi (
  id serial PRIMARY KEY,
  estado text NOT NULL DEFAULT 'en_proceso',
  tinta_id integer,
  tinta_nombre text NOT NULL DEFAULT '',
  nombre_producto text NOT NULL DEFAULT '',
  poe text NOT NULL DEFAULT '',
  lote_numero integer,
  cantidad_producto_g real,
  jeringas integer,
  volumen_jeringa_ml real NOT NULL DEFAULT 10,
  concentracion real,
  materias_primas jsonb NOT NULL DEFAULT '[]',
  proceso jsonb NOT NULL DEFAULT '{"temperatura":"70","tiempoMezclado":"5","tiempoReposo":"","otros":""}',
  controles jsonb NOT NULL DEFAULT '{"peso":true,"organoleptico":true,"vestimenta":true,"higiene":true}',
  aprobadas integer,
  rechazadas integer NOT NULL DEFAULT 0,
  fecha_hora_inicio text NOT NULL DEFAULT '',
  fecha_hora_fin text NOT NULL DEFAULT '',
  operador text NOT NULL DEFAULT '',
  fecha_elab text NOT NULL DEFAULT '',
  fecha_vto text NOT NULL DEFAULT '',
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS excipientes (
  id serial PRIMARY KEY,
  nombre text NOT NULL,
  activo boolean NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS medicos (
  id serial PRIMARY KEY,
  nombre text NOT NULL,
  matricula text NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS pacientes (
  id serial PRIMARY KEY,
  nombre text NOT NULL,
  dni text NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS operadores (
  id serial PRIMARY KEY,
  nombre text NOT NULL,
  rol text NOT NULL DEFAULT 'produce'
);

-- ---------- Catálogos iniciales ----------

INSERT INTO excipientes (nombre) VALUES
  ('PEG 4000'), ('Agua bidestilada'), ('Cera carnauba'),
  ('Aceite de girasol'), ('Propilenglicol');

INSERT INTO operadores (nombre, rol) VALUES
  ('Tomás Palmieri', 'produce'),
  ('Julieta Ferrucci', 'produce'),
  ('Gonzalo Angeleri', 'produce'),
  ('DT: Farm. Gonzalo A. Azategui MP 8288', 'revisa');

-- ---------- Las 65 tintas de MALVINAS ----------

INSERT INTO tintas (nombre, keywords, concentracion, ip, a_manopla, ubicacion, excipientes, parametros, alerta, poe) VALUES
  ('Aceite de pescado y aerosil (OGAP)', 'aceite de pescado y aerosil, aceite de pescado, omega, omega 3', 0.97, 0.9, false, 'cuerpo', '[{"nombre":"Aerosil","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Acetazolamida 40%', 'acetazolamida', 0.4, 1.25, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.833},{"nombre":"PG","fraccion":0.167}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":25,"velRet":25,"descarte":0,"pausaBal":1.5}'::jsonb, 'Respetar estricto orden de adición de solventes: incorporar el propilenglicol como primer agente humectante de la formulación.', ''),
  ('Acetazolamida 20%', 'acetazolamida', 0.2, 1.2, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.865},{"nombre":"PG","fraccion":0.135}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":25,"velRet":25,"descarte":0,"pausaBal":1.5}'::jsonb, 'Respetar estricto orden de adición de solventes: incorporar el propilenglicol como primer agente humectante de la formulación.', ''),
  ('Amitriptilina 3%', 'amitriptilina', 0.03, 1.11, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Ashwaganda 50%', 'ashwaganda', 0.5, 1.039, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":25,"velRet":25,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Ashwaganda salvavidas 60%', 'ashwaganda', 0.6, 1.039, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('B12 1.1%', 'b12, vit. b12, vitamina b12, cianocobalamina', 0.011, 0.989, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('B12 (concentrada) 5.45%', 'b12, vit. b12, vitamina b12, cianocobalamina', 0.0545, 0.989, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('B12 (diluida) 0.23%', 'b12, vit. b12, vitamina b12, cianocobalamina', 0.0023, 0.989, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('B6 Piridoxina 35%', 'b6 piridoxina, vit. b6, piridoxina, vitamina b6', 0.35, 1.026, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'PRECAUCIÓN: Incorporar el agua destilada exclusivamente después de la dispersión completa de la piridoxina para evitar un aumento abrupto de viscosidad y la gelificación indeseada de la matriz.', 'FPI.01.PI019'),
  ('B9 acido folico 0.43%', 'b9 acido folico, vit. b9, acido folico, folico', 0.0043, 0.912, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Bisglicinato de hierro 55%', 'bisglicinato de hierro', 0.55, 1.242, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Carbonato de Calcio 60%', 'carbonato de calcio', 0.6, 1.465, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'Riesgo de solidificación prematura en boquilla. Monitorear de forma estricta el flujo de extrusión continuo.', ''),
  ('Citrato de Calcio 50%', 'citrato de calcio', 0.5, 1.117, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'Alta tendencia a la solidificación prematura y aglomeración en boquilla. Configurar retracción en 0.1 y realizar un purgado amplio (descarte) antes de iniciar la impresión.', ''),
  ('Citrato de Calcio (Salvavidas) 55%', 'citrato de calcio', 0.55, 1.153, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('Citrato de magnesio 50%', 'citrato de magnesio, citrato de magnesio', 0.5, 1.295, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'Inestabilidad física en reposo (separación de fases). Requiere agitación mecánica vigorosa para su completa homogeneización inmediatamente previa a la fase de extrusión.', ''),
  ('Cloruro de Potasio 60%', 'cloruro de potasio', 0.6, 1.25, false, 'cuerpo', '[{"nombre":"Oleogel 5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'PRECAUCIÓN: Procesar y extruir estrictamente a temperatura ambiente (25°C). Riesgo elevado de precipitación rápida del principio activo en la matriz lipídica frente a estrés térmico.', ''),
  ('Vitamina D (impura) 13%', 'vitamina d, vit. d, vit. d3, vitamina d3, colecalciferol', 0.13, 0.9, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI007'),
  ('DHEA 30%', 'dhea', 0.3, 1.085, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.714},{"nombre":"PG","fraccion":0.286}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Dutasteride 0.2%', 'dutasteride', 0.002, 1.113, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.99},{"nombre":"PG","fraccion":0.01}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Dutasteride 0.4%', 'dutasteride', 0.004, 1.053, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.99},{"nombre":"PG","fraccion":0.01}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('GABA 50%', 'gaba', 0.5, 1, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":50,"velRet":50,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Ginkgo biloba 50%', 'ginkgo biloba', 0.5, 1.08, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Ginseng 50%', 'ginseng', 0.5, 1.11, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Ginseng salvavidas 60%', 'ginseng', 0.6, 1.26, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('Glicinato de magnesio 55%', 'glicinato de magnesio, glicinato de magnesio', 0.55, 1.2, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI003'),
  ('Hidrocortisona 1%', 'hidrocortisona', 0.01, 1.09, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Hidroxi Triptofano en Aerosil 40%', 'hidroxi triptofano en aerosil, 5-htp, hidroxitriptofano, hidroxi triptofano', 0.4, 1.083, false, 'cuerpo', '[{"nombre":"Aerosil 4%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Hierro quelado 60%', 'hierro quelado', 0.6, 1.26, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('L Teanina 40%', 'l teanina', 0.4, 0.955, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('L Teanina (salvavidas) 45%', 'l teanina', 0.45, 0.955, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('L-cistina 50%', 'l-cistina, l-cistina, cistina, l cistina', 0.5, 1.188, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI043'),
  ('L-Metionina salvavidas 50%', 'l-metionina', 0.5, 0.95, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('Lavanda 96%', 'lavanda', 0.96, 0.848, false, 'cuerpo', '[{"nombre":"Aerosil","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'Formular a temperatura ambiente bajo agitación magnética continua. Calentar a 70°C únicamente para la fase de impresión.', ''),
  ('Lev. Selenio 50%', 'lev. selenio, selenio, levadura de selenio', 0.5, 1.028, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI040'),
  ('Manganeso Quelado 40%', 'manganeso quelado', 0.4, 1.013, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Melatonina 15%', 'melatonina', 0.15, 1.11, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Melatonina (salvavidas) 20%', 'melatonina', 0.2, 1.093, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Melatonina para 2 mg 6.67%', 'melatonina', 0.0667, 1.093, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Minoxidil 1%', 'minoxidil', 0.01, 1.126, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.99},{"nombre":"PPG","fraccion":0.01}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Minoxidil 4%', 'minoxidil', 0.04, 1.1, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.99},{"nombre":"PPG","fraccion":0.01}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Minoxidil 8%', 'minoxidil', 0.08, 1.024, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.989},{"nombre":"PPG","fraccion":0.011}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Oleogel 2.5%', 'oleogel', 0.025, 0.9, false, 'cuerpo', '[{"nombre":"Aceite de girasol","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":50,"velRet":50,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI004'),
  ('Oleogel 5%', 'oleogel', 0.05, 0.9, false, 'cuerpo', '[{"nombre":"Aceite de girasol","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":50,"velRet":50,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Pantotenato de calcio 60%', 'pantotenato de calcio', 0.6, 1.11, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Progesterona 25%', 'progesterona', 0.25, 1.123, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.957},{"nombre":"PPG","fraccion":0.043}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Resveratrol 45%', 'resveratrol', 0.45, 1.045, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Resveratrol Salvavidas 50%', 'resveratrol', 0.5, 1.09, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, '', ''),
  ('Riboflavina 40%', 'riboflavina, vit. b2, riboflavina, vitamina b2', 0.4, 1.08, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Sulf. de Zn 20%', 'sulf. de zn, sulfato de zinc, zinc', 0.2, 1.095, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Tadalafilo 4.54%', 'tadalafilo', 0.0454, 1.2, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.79},{"nombre":"PG","fraccion":0.21}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Tiamina 40%', 'tiamina, vit. b1, tiamina, vitamina b1', 0.4, 1.032, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Tiamina 36%', 'tiamina, vit. b1, tiamina, vitamina b1', 0.36, 1.02, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Triptofano 30%', 'triptofano', 0.3, 0.912, true, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, NULL, 'Inestabilidad reológica durante la extrusión que compromete la uniformidad del lote. Se indica preparación estrictamente manual.', ''),
  ('Vit A 15%', 'vit a, vit. a, vitamina a, retinol', 0.15, 0.88, false, 'cuerpo', '[{"nombre":"Oleogel 5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Vit A 1.7%', 'vit a, vit. a, vitamina a, retinol', 0.017, 0.861, false, 'cuerpo', '[{"nombre":"Oleogel 5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Vit E 47.5%', 'vit e, vit. e, vitamina e, tocoferol', 0.475, 0.848, false, 'cuerpo', '[{"nombre":"Oleogel 5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Vitamina B9 acido folico 1.33%', 'vitamina b9 acido folico, vit. b9, acido folico, folico', 0.0133, 1.08, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Vitamina k2 0.15%', 'vitamina k2, vit. k2, vitamina k2, menaquinona', 0.0015, 1.07, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.99},{"nombre":"PG","fraccion":0.01}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":100,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', 'FPI.01.PI030'),
  ('Coenzima Q10 100%', 'coenzima q10', 1, 1, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":25,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Idebenona 100%', 'idebenona', 1, 1, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":25,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('PEG 4000 puro', 'peg 4000', 1, 1.11, false, 'cuerpo', '[]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":25,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Melatonina para 1 mg 3%', 'melatonina', 0.03, 1.093, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":25,"descarte":0.1,"pausaBal":1.5}'::jsonb, '', ''),
  ('Vit C 50%', 'vit c, vit. c, vitamina c, acido ascorbico', 0.5, 1.296, false, 'cuerpo', '[{"nombre":"Oleogel 2,5%","fraccion":1}]'::jsonb, '{"temp":70,"retraccion":0.05,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, 'MALAXAR previamente la vitamina C antes de cargar en jeringa.', ''),
  ('Amitriptilina 6%', 'amitriptilina', 0.06, 1.11, false, 'tapa', '[{"nombre":"PEG 4000","fraccion":0.8},{"nombre":"Agua destilada","fraccion":0.2}]'::jsonb, '{"temp":70,"retraccion":0,"pausa":0.5,"velExt":100,"velRet":0,"descarte":0.1,"pausaBal":1.5}'::jsonb, '3% solubilizada en agua y luego PEG 4000. Del excipiente total, 20% es agua destilada.', '');

-- ---------- Contador de lote PT ----------
-- Registro "semilla" para que el próximo lote de producto terminado
-- continúe la numeración actual de la farmacia.
-- ⚠ CAMBIAR EL 165 por el último número de lote PT real antes de correr.
INSERT INTO registros (estado, paciente, lote_prefijo, lote_numero)
  VALUES ('terminado', '— semilla de contador (borrar) —', 'PT001', 165);
