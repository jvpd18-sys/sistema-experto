-- SGBD: SQLite 3 (SQL estándar; portable a MySQL/PostgreSQL cambiando AUTOINCREMENT por AUTO_INCREMENT/SERIAL)
PRAGMA foreign_keys = ON;

-- ===== BASE DE CONOCIMIENTO =====
CREATE TABLE especie   (id_especie   INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(20) NOT NULL UNIQUE);
CREATE TABLE categoria (id_categoria INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(40) NOT NULL UNIQUE);
CREATE TABLE sintoma (
  id_sintoma INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo     VARCHAR(60)  NOT NULL UNIQUE,
  etiqueta   VARCHAR(120) NOT NULL,
  tipo       VARCHAR(12)  NOT NULL CHECK (tipo IN ('sintoma','antecedente')));
CREATE TABLE enfermedad (
  id_enfermedad  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_especie     INTEGER NOT NULL REFERENCES especie(id_especie),
  id_categoria   INTEGER NOT NULL REFERENCES categoria(id_categoria),
  nombre         VARCHAR(100) NOT NULL,
  descripcion    TEXT,
  nivel_atencion VARCHAR(12) NOT NULL CHECK (nivel_atencion IN ('informativo','consulta','urgencia')),
  UNIQUE (id_especie, nombre));
CREATE TABLE regla (
  id_regla          INTEGER PRIMARY KEY AUTOINCREMENT,
  id_enfermedad     INTEGER NOT NULL REFERENCES enfermedad(id_enfermedad) ON DELETE CASCADE,
  diagnostico       VARCHAR(120) NOT NULL,
  recomendacion     TEXT NOT NULL,
  cf                DECIMAL(3,2) NOT NULL CHECK (cf BETWEEN 0 AND 1),
  estado_validacion VARCHAR(12) NOT NULL DEFAULT 'pendiente' CHECK (estado_validacion IN ('pendiente','validada','rechazada')),
  activa            INTEGER NOT NULL DEFAULT 1 CHECK (activa IN (0,1)));
-- Gránulo de conocimiento: una condición (síntoma = valor). Mismo 'grupo' => OR; grupos distintos => AND.
CREATE TABLE regla_condicion (
  id_condicion   INTEGER PRIMARY KEY AUTOINCREMENT,
  id_regla       INTEGER NOT NULL REFERENCES regla(id_regla) ON DELETE CASCADE,
  id_sintoma     INTEGER NOT NULL REFERENCES sintoma(id_sintoma),
  valor_esperado VARCHAR(2) NOT NULL DEFAULT 'si' CHECK (valor_esperado IN ('si','no')),
  grupo          INTEGER NOT NULL DEFAULT 1);

-- ===== SISTEMA TRANSACCIONAL =====
CREATE TABLE rol (id_rol INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(20) NOT NULL UNIQUE, descripcion TEXT);
CREATE TABLE usuario (
  id_usuario    INTEGER PRIMARY KEY AUTOINCREMENT,
  id_rol        INTEGER NOT NULL REFERENCES rol(id_rol),
  nombre        VARCHAR(100) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  telefono      VARCHAR(20),
  edad          INTEGER CHECK (edad IS NULL OR edad >= 0),
  password_hash VARCHAR(255) NOT NULL,
  activo        INTEGER NOT NULL DEFAULT 1);
CREATE TABLE animal (
  id_animal  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
  id_especie INTEGER NOT NULL REFERENCES especie(id_especie),
  nombre     VARCHAR(60) NOT NULL,
  raza       VARCHAR(60),
  edad_anios DECIMAL(4,1),
  sexo       VARCHAR(1) CHECK (sexo IN ('M','H')));
CREATE TABLE consulta (
  id_consulta  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario   INTEGER NOT NULL REFERENCES usuario(id_usuario),
  id_animal    INTEGER NOT NULL REFERENCES animal(id_animal),
  id_categoria INTEGER REFERENCES categoria(id_categoria),   -- NULL = consulta general (todos los síntomas)
  fecha        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  prioridad    VARCHAR(12) NOT NULL DEFAULT 'normal' CHECK (prioridad IN ('normal','inmediata')));
CREATE TABLE consulta_respuesta (
  id_consulta INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
  id_sintoma  INTEGER NOT NULL REFERENCES sintoma(id_sintoma),
  respuesta   VARCHAR(4) NOT NULL CHECK (respuesta IN ('si','no','nose')),
  PRIMARY KEY (id_consulta, id_sintoma));
CREATE TABLE consulta_resultado (
  id_consulta  INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
  id_regla     INTEGER NOT NULL REFERENCES regla(id_regla),
  tipo         VARCHAR(8) NOT NULL CHECK (tipo IN ('total','parcial')),
  coincidencia DECIMAL(3,2) NOT NULL,
  cf_resultado DECIMAL(3,2) NOT NULL,
  probabilidad DECIMAL(4,1) NOT NULL DEFAULT 0,   -- % relativo entre las hipótesis mostradas
  PRIMARY KEY (id_consulta, id_regla));
CREATE TABLE auditoria_conocimiento (
  id_auditoria INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario   INTEGER NOT NULL REFERENCES usuario(id_usuario),
  fecha        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  entidad      VARCHAR(30) NOT NULL,
  id_entidad   INTEGER,
  accion       VARCHAR(20) NOT NULL,
  detalle      TEXT);
CREATE INDEX ix_enf_esp_cat ON enfermedad(id_especie, id_categoria);
CREATE INDEX ix_cond_regla  ON regla_condicion(id_regla);
CREATE INDEX ix_cons_user   ON consulta(id_usuario, fecha);
