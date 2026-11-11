BEGIN TRANSACTION;
CREATE TABLE animal (
  id_animal  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario),
  id_especie INTEGER NOT NULL REFERENCES especie(id_especie),
  nombre     VARCHAR(60) NOT NULL,
  raza       VARCHAR(60),
  edad_anios DECIMAL(4,1),
  sexo       VARCHAR(1) CHECK (sexo IN ('M','H')));
INSERT INTO "animal" VALUES(1,3,1,'Firulais',NULL,NULL,NULL);
CREATE TABLE auditoria_conocimiento (
  id_auditoria INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario   INTEGER NOT NULL REFERENCES usuario(id_usuario),
  fecha        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  entidad      VARCHAR(30) NOT NULL,
  id_entidad   INTEGER,
  accion       VARCHAR(20) NOT NULL,
  detalle      TEXT);
CREATE TABLE categoria (id_categoria INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(40) NOT NULL UNIQUE);
INSERT INTO "categoria" VALUES(1,'Bucodental');
INSERT INTO "categoria" VALUES(2,'Dermatológico');
INSERT INTO "categoria" VALUES(3,'Digestivo');
INSERT INTO "categoria" VALUES(4,'Emergencia');
INSERT INTO "categoria" VALUES(5,'Infeccioso sistémico');
INSERT INTO "categoria" VALUES(6,'Metabólico y renal');
INSERT INTO "categoria" VALUES(7,'Otológico');
INSERT INTO "categoria" VALUES(8,'Respiratorio');
INSERT INTO "categoria" VALUES(9,'Urinario');
CREATE TABLE consulta (
  id_consulta  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_usuario   INTEGER NOT NULL REFERENCES usuario(id_usuario),
  id_animal    INTEGER NOT NULL REFERENCES animal(id_animal),
  id_categoria INTEGER REFERENCES categoria(id_categoria),   -- NULL = consulta general (todos los síntomas)
  fecha        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  prioridad    VARCHAR(12) NOT NULL DEFAULT 'normal' CHECK (prioridad IN ('normal','inmediata')));
INSERT INTO "consulta" VALUES(1,3,1,3,'2026-11-10 23:51:22','normal');
INSERT INTO "consulta" VALUES(2,3,1,NULL,'2026-11-10 23:51:22','inmediata');
INSERT INTO "consulta" VALUES(3,3,1,3,'2026-11-10 23:51:22','inmediata');
CREATE TABLE consulta_respuesta (
  id_consulta INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
  id_sintoma  INTEGER NOT NULL REFERENCES sintoma(id_sintoma),
  respuesta   VARCHAR(4) NOT NULL CHECK (respuesta IN ('si','no','nose')),
  PRIMARY KEY (id_consulta, id_sintoma));
INSERT INTO "consulta_respuesta" VALUES(1,1,'si');
INSERT INTO "consulta_respuesta" VALUES(1,2,'si');
INSERT INTO "consulta_respuesta" VALUES(1,4,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,5,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,6,'si');
INSERT INTO "consulta_respuesta" VALUES(1,8,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,10,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,11,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,12,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,13,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,14,'si');
INSERT INTO "consulta_respuesta" VALUES(1,15,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,17,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,18,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,19,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,20,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,23,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,24,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,25,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,33,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,53,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,54,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,3,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,7,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,9,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,16,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,21,'nose');
INSERT INTO "consulta_respuesta" VALUES(1,22,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,4,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,40,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,19,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,5,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,53,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,54,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,35,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,2,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,8,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,20,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,33,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,6,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,28,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,13,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,32,'si');
INSERT INTO "consulta_respuesta" VALUES(2,25,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,24,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,18,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,23,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,43,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,36,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,26,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,45,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,12,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,11,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,37,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,34,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,39,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,42,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,38,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,14,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,10,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,47,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,17,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,46,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,27,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,51,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,50,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,48,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,44,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,52,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,31,'si');
INSERT INTO "consulta_respuesta" VALUES(2,29,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,1,'si');
INSERT INTO "consulta_respuesta" VALUES(2,15,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,3,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,49,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,7,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,22,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,30,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,16,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,21,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,41,'nose');
INSERT INTO "consulta_respuesta" VALUES(2,9,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,1,'si');
INSERT INTO "consulta_respuesta" VALUES(3,2,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,4,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,5,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,6,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,8,'si');
INSERT INTO "consulta_respuesta" VALUES(3,10,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,11,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,12,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,13,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,14,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,15,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,17,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,18,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,19,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,20,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,23,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,24,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,25,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,33,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,53,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,54,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,3,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,7,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,9,'no');
INSERT INTO "consulta_respuesta" VALUES(3,16,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,21,'nose');
INSERT INTO "consulta_respuesta" VALUES(3,22,'nose');
CREATE TABLE consulta_resultado (
  id_consulta  INTEGER NOT NULL REFERENCES consulta(id_consulta) ON DELETE CASCADE,
  id_regla     INTEGER NOT NULL REFERENCES regla(id_regla),
  tipo         VARCHAR(8) NOT NULL CHECK (tipo IN ('total','parcial')),
  coincidencia DECIMAL(3,2) NOT NULL,
  cf_resultado DECIMAL(3,2) NOT NULL,
  probabilidad DECIMAL(4,1) NOT NULL DEFAULT 0,   -- % relativo entre las hipótesis mostradas
  PRIMARY KEY (id_consulta, id_regla));
INSERT INTO "consulta_resultado" VALUES(1,8,'total',1,0.7,34.3);
INSERT INTO "consulta_resultado" VALUES(1,13,'parcial',0.67,0.53,17.4);
INSERT INTO "consulta_resultado" VALUES(1,1,'parcial',0.67,0.5,16.3);
INSERT INTO "consulta_resultado" VALUES(1,4,'parcial',0.67,0.47,15.2);
INSERT INTO "consulta_resultado" VALUES(1,23,'parcial',0.5,0.38,9.2);
INSERT INTO "consulta_resultado" VALUES(1,3,'parcial',0.5,0.31,7.5);
INSERT INTO "consulta_resultado" VALUES(2,17,'parcial',0.67,0.57,34.9);
INSERT INTO "consulta_resultado" VALUES(2,25,'parcial',0.67,0.53,32.8);
INSERT INTO "consulta_resultado" VALUES(2,5,'parcial',0.33,0.3,9.2);
INSERT INTO "consulta_resultado" VALUES(2,13,'parcial',0.33,0.27,8.2);
INSERT INTO "consulta_resultado" VALUES(2,1,'parcial',0.33,0.25,7.7);
INSERT INTO "consulta_resultado" VALUES(2,8,'parcial',0.33,0.23,7.2);
INSERT INTO "consulta_resultado" VALUES(3,5,'total',1,0.9,72.6);
INSERT INTO "consulta_resultado" VALUES(3,13,'parcial',0.33,0.27,7.2);
INSERT INTO "consulta_resultado" VALUES(3,25,'parcial',0.33,0.27,7.2);
INSERT INTO "consulta_resultado" VALUES(3,1,'parcial',0.33,0.25,6.7);
INSERT INTO "consulta_resultado" VALUES(3,8,'parcial',0.33,0.23,6.3);
CREATE TABLE enfermedad (
  id_enfermedad  INTEGER PRIMARY KEY AUTOINCREMENT,
  id_especie     INTEGER NOT NULL REFERENCES especie(id_especie),
  id_categoria   INTEGER NOT NULL REFERENCES categoria(id_categoria),
  nombre         VARCHAR(100) NOT NULL,
  descripcion    TEXT,
  nivel_atencion VARCHAR(12) NOT NULL CHECK (nivel_atencion IN ('informativo','consulta','urgencia')),
  UNIQUE (id_especie, nombre));
INSERT INTO "enfermedad" VALUES(1,1,3,'Gastroenteritis alimentaria','Gastroenteritis alimentaria','informativo');
INSERT INTO "enfermedad" VALUES(2,1,3,'Torsión gástrica','dilatación-vólvulo gástrico','urgencia');
INSERT INTO "enfermedad" VALUES(3,1,3,'Gastritis','gastritis','consulta');
INSERT INTO "enfermedad" VALUES(4,1,3,'Enteritis','enteritis','consulta');
INSERT INTO "enfermedad" VALUES(5,1,3,'Parvovirosis canina','parvovirosis canina','urgencia');
INSERT INTO "enfermedad" VALUES(6,1,3,'Parasitosis intestinal','parasitosis intestinal','consulta');
INSERT INTO "enfermedad" VALUES(7,1,3,'Colitis','colitis','consulta');
INSERT INTO "enfermedad" VALUES(8,1,3,'Pancreatitis','pancreatitis','consulta');
INSERT INTO "enfermedad" VALUES(9,1,3,'Obstrucción intestinal','obstrucción intestinal','urgencia');
INSERT INTO "enfermedad" VALUES(10,1,3,'Megaesófago','megaesófago','consulta');
INSERT INTO "enfermedad" VALUES(11,1,3,'Insuficiencia pancreática exocrina','insuficiencia pancreática exocrina','consulta');
INSERT INTO "enfermedad" VALUES(12,1,3,'Reacción adversa alimentaria','reacción adversa alimentaria','consulta');
INSERT INTO "enfermedad" VALUES(13,1,3,'Enfermedad hepática','enfermedad hepática','consulta');
INSERT INTO "enfermedad" VALUES(14,1,3,'Estreñimiento','estreñimiento','informativo');
INSERT INTO "enfermedad" VALUES(15,1,1,'Enfermedad periodontal','enfermedad periodontal','consulta');
INSERT INTO "enfermedad" VALUES(16,1,8,'Tos de las perreras','tos de las perreras','consulta');
INSERT INTO "enfermedad" VALUES(17,1,8,'Neumonía canina','neumonía canina','urgencia');
INSERT INTO "enfermedad" VALUES(18,1,2,'Sarna sarcóptica','sarna sarcóptica','consulta');
INSERT INTO "enfermedad" VALUES(19,1,2,'Dermatitis por pulgas','dermatitis por pulgas','informativo');
INSERT INTO "enfermedad" VALUES(20,1,2,'Dermatitis atópica','dermatitis atópica','consulta');
INSERT INTO "enfermedad" VALUES(21,1,2,'Dermatitis alérgica','dermatitis alérgica','consulta');
INSERT INTO "enfermedad" VALUES(22,1,6,'Diabetes mellitus canina','diabetes mellitus canina','consulta');
INSERT INTO "enfermedad" VALUES(23,1,6,'Insuficiencia renal crónica','enfermedad renal crónica','consulta');
INSERT INTO "enfermedad" VALUES(24,1,7,'Otitis externa','otitis externa','consulta');
INSERT INTO "enfermedad" VALUES(25,1,5,'Leptospirosis','leptospirosis','consulta');
INSERT INTO "enfermedad" VALUES(26,1,5,'Moquillo canino','moquillo canino','urgencia');
INSERT INTO "enfermedad" VALUES(27,1,4,'Emergencia respiratoria o neurológica','Emergencia veterinaria','urgencia');
INSERT INTO "enfermedad" VALUES(28,2,3,'Panleucopenia felina','panleucopenia felina','urgencia');
INSERT INTO "enfermedad" VALUES(29,2,3,'Gastroenteritis alimentaria felina','gastroenteritis alimentaria felina','informativo');
INSERT INTO "enfermedad" VALUES(30,2,8,'Calicivirus felino','calicivirus felino','consulta');
INSERT INTO "enfermedad" VALUES(31,2,8,'Rinotraqueítis viral felina (herpesvirus felino)','rinotraqueítis viral felina','consulta');
INSERT INTO "enfermedad" VALUES(32,2,8,'Asma felina','asma felina','consulta');
INSERT INTO "enfermedad" VALUES(33,2,2,'Dermatitis por pulgas felina','dermatitis por pulgas','informativo');
INSERT INTO "enfermedad" VALUES(34,2,2,'Dermatitis alérgica felina','dermatitis alérgica felina','consulta');
INSERT INTO "enfermedad" VALUES(35,2,2,'Sarna notoédrica','sarna notoédrica','consulta');
INSERT INTO "enfermedad" VALUES(36,2,3,'Parasitosis intestinal felina','parasitosis intestinal felina','consulta');
INSERT INTO "enfermedad" VALUES(37,2,6,'Diabetes mellitus felina','diabetes mellitus felina','consulta');
INSERT INTO "enfermedad" VALUES(38,2,6,'Insuficiencia renal crónica felina','enfermedad renal crónica felina','consulta');
INSERT INTO "enfermedad" VALUES(39,2,6,'Hipertiroidismo felino','hipertiroidismo felino','consulta');
INSERT INTO "enfermedad" VALUES(40,2,7,'Otitis externa felina','otitis externa felina','consulta');
INSERT INTO "enfermedad" VALUES(41,2,1,'Estomatitis felina','estomatitis felina','consulta');
INSERT INTO "enfermedad" VALUES(42,2,9,'Obstrucción urinaria felina','obstrucción urinaria','urgencia');
INSERT INTO "enfermedad" VALUES(43,2,9,'Enfermedad del tracto urinario inferior felino (FLUTD)','FLUTD','consulta');
INSERT INTO "enfermedad" VALUES(44,2,9,'Cistitis felina','cistitis felina','consulta');
INSERT INTO "enfermedad" VALUES(45,2,4,'Emergencia felina','Emergencia veterinaria','urgencia');
CREATE TABLE especie   (id_especie   INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(20) NOT NULL UNIQUE);
INSERT INTO "especie" VALUES(1,'Perro');
INSERT INTO "especie" VALUES(2,'Gato');
CREATE TABLE regla (
  id_regla          INTEGER PRIMARY KEY AUTOINCREMENT,
  id_enfermedad     INTEGER NOT NULL REFERENCES enfermedad(id_enfermedad) ON DELETE CASCADE,
  diagnostico       VARCHAR(120) NOT NULL,
  recomendacion     TEXT NOT NULL,
  cf                DECIMAL(3,2) NOT NULL CHECK (cf BETWEEN 0 AND 1),
  estado_validacion VARCHAR(12) NOT NULL DEFAULT 'pendiente' CHECK (estado_validacion IN ('pendiente','validada','rechazada')),
  activa            INTEGER NOT NULL DEFAULT 1 CHECK (activa IN (0,1)));
INSERT INTO "regla" VALUES(1,1,'Gastroenteritis alimentaria','Suspender el acceso al alimento sospechoso, mantener agua disponible si puede beber sin vomitar y consultar al veterinario si los síntomas persisten o empeoran.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(2,2,'Sospecha de dilatación-vólvulo gástrico','Atención veterinaria de emergencia inmediata. No administrar alimentos, agua ni medicamentos por la fuerza.',0.95,'pendiente',1);
INSERT INTO "regla" VALUES(3,3,'Posible gastritis','Solicitar evaluación veterinaria para determinar la causa del vómito y evitar medicamentos sin prescripción.',0.7,'pendiente',1);
INSERT INTO "regla" VALUES(4,4,'Posible enteritis','Evaluación veterinaria, vigilancia de la hidratación y análisis de heces cuando esté indicado.',0.7,'pendiente',1);
INSERT INTO "regla" VALUES(5,5,'Sospecha de parvovirosis canina','Atención veterinaria urgente, aislamiento de otros perros y tratamiento de soporte bajo supervisión veterinaria, que puede incluir fluidoterapia intravenosa.',0.9,'pendiente',1);
INSERT INTO "regla" VALUES(6,6,'Posible parasitosis intestinal','Realizar examen de heces y administrar el antiparasitario apropiado según indicación veterinaria.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(7,7,'Posible colitis','Evaluación veterinaria para investigar causas inflamatorias, parasitarias o alimentarias.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(8,8,'Posible pancreatitis','Valoración veterinaria pronta; confirmar mediante exploración y pruebas diagnósticas apropiadas.',0.7,'pendiente',1);
INSERT INTO "regla" VALUES(9,9,'Sospecha de obstrucción intestinal','Atención veterinaria urgente. No inducir el vómito ni administrar remedios caseros.',0.9,'pendiente',1);
INSERT INTO "regla" VALUES(10,10,'Posible megaesófago','Evaluación veterinaria e investigación de alteraciones del esófago; vigilar signos respiratorios por posible aspiración.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(11,11,'Posible insuficiencia pancreática exocrina','Consultar al veterinario para realizar pruebas de función pancreática y valorar tratamiento nutricional y enzimático.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(12,12,'Posible reacción adversa alimentaria','Evaluación veterinaria y posible dieta de eliminación supervisada.',0.7,'pendiente',1);
INSERT INTO "regla" VALUES(13,13,'Posible enfermedad hepática','Atención veterinaria pronta para realizar pruebas hepáticas y determinar la causa.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(14,14,'Posible estreñimiento','Evaluación veterinaria si persiste, existe dolor o hay vómitos; evitar laxantes sin indicación profesional.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(15,15,'Posible enfermedad periodontal','Revisión odontológica veterinaria y limpieza profesional cuando esté indicada.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(16,16,'Posible tos de las perreras','Consulta veterinaria y evitar el contacto con otros perros hasta determinar la causa.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(17,17,'Sospecha de neumonía canina','Atención veterinaria urgente, especialmente si existe dificultad respiratoria.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(18,18,'Posible sarna sarcóptica','Evaluación dermatológica veterinaria y tratamiento antiparasitario indicado.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(19,19,'Posible dermatitis por pulgas','Control antiparasitario adecuado para el perro y su entorno, siguiendo indicación veterinaria.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(20,20,'Posible dermatitis atópica','Consulta veterinaria para investigar alergias y descartar parásitos e infecciones cutáneas.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(21,21,'Posible dermatitis alérgica','Identificar posibles desencadenantes con apoyo veterinario y evitar tratamientos tópicos no prescritos.',0.7,'pendiente',1);
INSERT INTO "regla" VALUES(22,22,'Posible diabetes mellitus canina','Realizar evaluación veterinaria, glucemia y análisis de orina.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(23,23,'Posible enfermedad renal crónica','Evaluación veterinaria con análisis de sangre y orina; el diagnóstico requiere pruebas específicas.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(24,24,'Posible otitis externa','Examen del oído y tratamiento veterinario según la causa.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(25,25,'Sospecha de leptospirosis','Atención veterinaria pronta y medidas de higiene para reducir la exposición a la orina del animal, ya que puede existir riesgo zoonótico.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(26,26,'Sospecha de moquillo canino','Atención veterinaria urgente, aislamiento y pruebas diagnósticas.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(27,27,'Emergencia veterinaria','Traslado inmediato a un servicio veterinario de urgencias.',0.99,'pendiente',1);
INSERT INTO "regla" VALUES(28,28,'Sospecha de panleucopenia felina','Atención veterinaria urgente, aislamiento y tratamiento de soporte bajo supervisión profesional.',0.9,'pendiente',1);
INSERT INTO "regla" VALUES(29,29,'Posible gastroenteritis alimentaria felina','Consulta veterinaria si los síntomas persisten, son intensos o afectan la hidratación.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(30,30,'Posible calicivirus felino','Evaluación veterinaria, aislamiento preventivo y cuidados de soporte según indicación.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(31,31,'Posible rinotraqueítis viral felina','Evaluación veterinaria, higiene ocular según indicación y reducción del contacto con otros gatos.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(32,32,'Posible asma felina','Evaluación veterinaria; si tiene dificultad respiratoria, acudir a urgencias inmediatamente.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(33,33,'Posible dermatitis por pulgas','Evaluación dermatológica y control antiparasitario seguro para gatos.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(34,34,'Posible dermatitis alérgica felina','Evaluación veterinaria para descartar pulgas, ácaros, infecciones y otras alergias.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(35,35,'Posible sarna notoédrica','Atención veterinaria y tratamiento antiparasitario específico para gatos.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(36,36,'Posible parasitosis intestinal felina','Análisis de heces y tratamiento antiparasitario bajo supervisión veterinaria.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(37,37,'Posible diabetes mellitus felina','Evaluación veterinaria con pruebas de glucosa y orina.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(38,38,'Posible enfermedad renal crónica felina','Evaluación veterinaria y pruebas de sangre y orina.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(39,39,'Posible hipertiroidismo felino','Consulta veterinaria y medición de hormonas tiroideas.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(40,40,'Posible otitis externa felina','Examen del oído y tratamiento según la causa identificada.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(41,41,'Posible estomatitis felina','Evaluación veterinaria odontológica y manejo del dolor prescrito.',0.85,'pendiente',1);
INSERT INTO "regla" VALUES(42,42,'Sospecha de obstrucción urinaria','Atención veterinaria de emergencia inmediata. No presionar el abdomen ni intentar desobstruir en casa.',0.95,'pendiente',1);
INSERT INTO "regla" VALUES(43,43,'Posible FLUTD','Evaluación veterinaria pronta para determinar la causa y descartar obstrucción.',0.8,'pendiente',1);
INSERT INTO "regla" VALUES(44,44,'Posible cistitis felina','Consulta veterinaria y análisis de orina. No asumir que todos los síntomas urinarios son causados por cistitis.',0.75,'pendiente',1);
INSERT INTO "regla" VALUES(45,45,'Emergencia veterinaria','Traslado inmediato a urgencias veterinarias.',0.99,'pendiente',1);
CREATE TABLE regla_condicion (
  id_condicion   INTEGER PRIMARY KEY AUTOINCREMENT,
  id_regla       INTEGER NOT NULL REFERENCES regla(id_regla) ON DELETE CASCADE,
  id_sintoma     INTEGER NOT NULL REFERENCES sintoma(id_sintoma),
  valor_esperado VARCHAR(2) NOT NULL DEFAULT 'si' CHECK (valor_esperado IN ('si','no')),
  grupo          INTEGER NOT NULL DEFAULT 1);
INSERT INTO "regla_condicion" VALUES(1,1,1,'si',2);
INSERT INTO "regla_condicion" VALUES(2,1,2,'si',3);
INSERT INTO "regla_condicion" VALUES(3,1,3,'si',4);
INSERT INTO "regla_condicion" VALUES(4,2,4,'si',2);
INSERT INTO "regla_condicion" VALUES(5,2,5,'si',3);
INSERT INTO "regla_condicion" VALUES(6,3,1,'si',2);
INSERT INTO "regla_condicion" VALUES(7,3,6,'si',3);
INSERT INTO "regla_condicion" VALUES(8,3,2,'no',4);
INSERT INTO "regla_condicion" VALUES(9,3,3,'si',5);
INSERT INTO "regla_condicion" VALUES(10,4,2,'si',2);
INSERT INTO "regla_condicion" VALUES(11,4,6,'si',3);
INSERT INTO "regla_condicion" VALUES(12,4,7,'si',4);
INSERT INTO "regla_condicion" VALUES(13,5,1,'si',2);
INSERT INTO "regla_condicion" VALUES(14,5,8,'si',3);
INSERT INTO "regla_condicion" VALUES(15,5,9,'no',4);
INSERT INTO "regla_condicion" VALUES(16,6,2,'si',2);
INSERT INTO "regla_condicion" VALUES(17,6,10,'si',3);
INSERT INTO "regla_condicion" VALUES(18,6,11,'si',4);
INSERT INTO "regla_condicion" VALUES(19,7,2,'si',2);
INSERT INTO "regla_condicion" VALUES(20,7,12,'si',3);
INSERT INTO "regla_condicion" VALUES(21,7,13,'si',4);
INSERT INTO "regla_condicion" VALUES(22,8,1,'si',2);
INSERT INTO "regla_condicion" VALUES(23,8,6,'si',3);
INSERT INTO "regla_condicion" VALUES(24,8,14,'si',4);
INSERT INTO "regla_condicion" VALUES(25,9,15,'si',2);
INSERT INTO "regla_condicion" VALUES(26,9,16,'si',3);
INSERT INTO "regla_condicion" VALUES(27,9,6,'si',4);
INSERT INTO "regla_condicion" VALUES(28,10,17,'si',2);
INSERT INTO "regla_condicion" VALUES(29,10,10,'si',3);
INSERT INTO "regla_condicion" VALUES(30,11,18,'si',2);
INSERT INTO "regla_condicion" VALUES(31,11,10,'si',3);
INSERT INTO "regla_condicion" VALUES(32,11,19,'si',4);
INSERT INTO "regla_condicion" VALUES(33,12,20,'si',2);
INSERT INTO "regla_condicion" VALUES(34,12,21,'si',3);
INSERT INTO "regla_condicion" VALUES(35,12,22,'si',4);
INSERT INTO "regla_condicion" VALUES(36,13,23,'si',2);
INSERT INTO "regla_condicion" VALUES(37,13,14,'si',3);
INSERT INTO "regla_condicion" VALUES(38,13,1,'si',4);
INSERT INTO "regla_condicion" VALUES(39,14,13,'si',2);
INSERT INTO "regla_condicion" VALUES(40,14,24,'si',3);
INSERT INTO "regla_condicion" VALUES(41,14,25,'si',4);
INSERT INTO "regla_condicion" VALUES(42,15,26,'si',2);
INSERT INTO "regla_condicion" VALUES(43,15,27,'si',3);
INSERT INTO "regla_condicion" VALUES(44,15,28,'si',4);
INSERT INTO "regla_condicion" VALUES(45,16,29,'si',2);
INSERT INTO "regla_condicion" VALUES(46,16,30,'si',3);
INSERT INTO "regla_condicion" VALUES(47,17,31,'si',2);
INSERT INTO "regla_condicion" VALUES(48,17,32,'si',3);
INSERT INTO "regla_condicion" VALUES(49,17,33,'si',4);
INSERT INTO "regla_condicion" VALUES(50,18,34,'si',2);
INSERT INTO "regla_condicion" VALUES(51,18,35,'si',3);
INSERT INTO "regla_condicion" VALUES(52,18,36,'si',4);
INSERT INTO "regla_condicion" VALUES(53,19,37,'si',2);
INSERT INTO "regla_condicion" VALUES(54,19,38,'si',3);
INSERT INTO "regla_condicion" VALUES(55,20,39,'si',2);
INSERT INTO "regla_condicion" VALUES(56,20,40,'si',3);
INSERT INTO "regla_condicion" VALUES(57,20,41,'si',4);
INSERT INTO "regla_condicion" VALUES(58,21,42,'si',2);
INSERT INTO "regla_condicion" VALUES(59,21,37,'si',3);
INSERT INTO "regla_condicion" VALUES(60,21,43,'si',4);
INSERT INTO "regla_condicion" VALUES(61,22,44,'si',2);
INSERT INTO "regla_condicion" VALUES(62,22,45,'si',3);
INSERT INTO "regla_condicion" VALUES(63,22,10,'si',4);
INSERT INTO "regla_condicion" VALUES(64,23,44,'si',2);
INSERT INTO "regla_condicion" VALUES(65,23,10,'si',3);
INSERT INTO "regla_condicion" VALUES(66,23,1,'si',4);
INSERT INTO "regla_condicion" VALUES(67,23,14,'si',5);
INSERT INTO "regla_condicion" VALUES(68,24,46,'si',2);
INSERT INTO "regla_condicion" VALUES(69,24,47,'si',3);
INSERT INTO "regla_condicion" VALUES(70,24,48,'si',4);
INSERT INTO "regla_condicion" VALUES(71,25,32,'si',2);
INSERT INTO "regla_condicion" VALUES(72,25,1,'si',3);
INSERT INTO "regla_condicion" VALUES(73,25,49,'si',4);
INSERT INTO "regla_condicion" VALUES(74,26,50,'si',2);
INSERT INTO "regla_condicion" VALUES(75,26,51,'si',3);
INSERT INTO "regla_condicion" VALUES(76,26,52,'si',4);
INSERT INTO "regla_condicion" VALUES(77,27,33,'si',1);
INSERT INTO "regla_condicion" VALUES(78,27,53,'si',1);
INSERT INTO "regla_condicion" VALUES(79,27,54,'si',1);
INSERT INTO "regla_condicion" VALUES(80,28,1,'si',2);
INSERT INTO "regla_condicion" VALUES(81,28,2,'si',3);
INSERT INTO "regla_condicion" VALUES(82,28,55,'si',4);
INSERT INTO "regla_condicion" VALUES(83,28,56,'no',5);
INSERT INTO "regla_condicion" VALUES(84,29,1,'si',2);
INSERT INTO "regla_condicion" VALUES(85,29,2,'si',3);
INSERT INTO "regla_condicion" VALUES(86,29,57,'si',4);
INSERT INTO "regla_condicion" VALUES(87,30,58,'si',2);
INSERT INTO "regla_condicion" VALUES(88,30,59,'si',3);
INSERT INTO "regla_condicion" VALUES(89,30,51,'si',4);
INSERT INTO "regla_condicion" VALUES(90,31,59,'si',2);
INSERT INTO "regla_condicion" VALUES(91,31,50,'si',3);
INSERT INTO "regla_condicion" VALUES(92,31,51,'si',4);
INSERT INTO "regla_condicion" VALUES(93,32,60,'si',2);
INSERT INTO "regla_condicion" VALUES(94,32,61,'si',3);
INSERT INTO "regla_condicion" VALUES(95,33,37,'si',2);
INSERT INTO "regla_condicion" VALUES(96,33,62,'si',3);
INSERT INTO "regla_condicion" VALUES(97,34,37,'si',2);
INSERT INTO "regla_condicion" VALUES(98,34,63,'si',3);
INSERT INTO "regla_condicion" VALUES(99,34,64,'si',4);
INSERT INTO "regla_condicion" VALUES(100,35,34,'si',2);
INSERT INTO "regla_condicion" VALUES(101,35,35,'si',3);
INSERT INTO "regla_condicion" VALUES(102,35,65,'si',4);
INSERT INTO "regla_condicion" VALUES(103,36,2,'si',2);
INSERT INTO "regla_condicion" VALUES(104,36,10,'si',3);
INSERT INTO "regla_condicion" VALUES(105,36,11,'si',4);
INSERT INTO "regla_condicion" VALUES(106,37,44,'si',2);
INSERT INTO "regla_condicion" VALUES(107,37,45,'si',3);
INSERT INTO "regla_condicion" VALUES(108,37,10,'si',4);
INSERT INTO "regla_condicion" VALUES(109,38,44,'si',2);
INSERT INTO "regla_condicion" VALUES(110,38,10,'si',3);
INSERT INTO "regla_condicion" VALUES(111,38,14,'si',4);
INSERT INTO "regla_condicion" VALUES(112,38,1,'si',5);
INSERT INTO "regla_condicion" VALUES(113,39,10,'si',2);
INSERT INTO "regla_condicion" VALUES(114,39,19,'si',3);
INSERT INTO "regla_condicion" VALUES(115,39,66,'si',4);
INSERT INTO "regla_condicion" VALUES(116,39,67,'si',5);
INSERT INTO "regla_condicion" VALUES(117,40,47,'si',2);
INSERT INTO "regla_condicion" VALUES(118,40,46,'si',3);
INSERT INTO "regla_condicion" VALUES(119,40,48,'si',4);
INSERT INTO "regla_condicion" VALUES(120,41,68,'si',2);
INSERT INTO "regla_condicion" VALUES(121,41,69,'si',3);
INSERT INTO "regla_condicion" VALUES(122,41,70,'si',4);
INSERT INTO "regla_condicion" VALUES(123,42,71,'si',2);
INSERT INTO "regla_condicion" VALUES(124,42,72,'si',3);
INSERT INTO "regla_condicion" VALUES(125,43,73,'si',2);
INSERT INTO "regla_condicion" VALUES(126,43,74,'si',3);
INSERT INTO "regla_condicion" VALUES(127,43,75,'si',4);
INSERT INTO "regla_condicion" VALUES(128,44,73,'si',2);
INSERT INTO "regla_condicion" VALUES(129,44,74,'si',3);
INSERT INTO "regla_condicion" VALUES(130,44,76,'si',4);
INSERT INTO "regla_condicion" VALUES(131,45,33,'si',1);
INSERT INTO "regla_condicion" VALUES(132,45,53,'si',1);
INSERT INTO "regla_condicion" VALUES(133,45,54,'si',1);
CREATE TABLE rol (id_rol INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(20) NOT NULL UNIQUE, descripcion TEXT);
INSERT INTO "rol" VALUES(1,'Consultante','Dueño del animal: registra animales y realiza consultas.');
INSERT INTO "rol" VALUES(2,'Experto','Veterinario: valida y gestiona enfermedades, síntomas y reglas.');
INSERT INTO "rol" VALUES(3,'Administrador','Gestiona usuarios y roles.');
CREATE TABLE sintoma (
  id_sintoma INTEGER PRIMARY KEY AUTOINCREMENT,
  codigo     VARCHAR(60)  NOT NULL UNIQUE,
  etiqueta   VARCHAR(120) NOT NULL,
  tipo       VARCHAR(12)  NOT NULL CHECK (tipo IN ('sintoma','antecedente')));
INSERT INTO "sintoma" VALUES(1,'vomitos','Vómitos','sintoma');
INSERT INTO "sintoma" VALUES(2,'diarrea','Diarrea','sintoma');
INSERT INTO "sintoma" VALUES(3,'consumo_alimento_inusual','Consumo alimento inusual','antecedente');
INSERT INTO "sintoma" VALUES(4,'abdomen_hinchado','Abdomen hinchado','sintoma');
INSERT INTO "sintoma" VALUES(5,'arcadas_sin_vomitar','Arcadas sin vomitar','sintoma');
INSERT INTO "sintoma" VALUES(6,'dolor_abdominal','Dolor abdominal','sintoma');
INSERT INTO "sintoma" VALUES(7,'exposicion_alimento_contaminado','Exposición alimento contaminado','antecedente');
INSERT INTO "sintoma" VALUES(8,'diarrea_con_sangre','Diarrea con sangre','sintoma');
INSERT INTO "sintoma" VALUES(9,'vacunado_parvovirus','Vacunado contra parvovirus','antecedente');
INSERT INTO "sintoma" VALUES(10,'perdida_peso','Pérdida peso','sintoma');
INSERT INTO "sintoma" VALUES(11,'parasitos_visibles_heces','Parásitos visibles heces','sintoma');
INSERT INTO "sintoma" VALUES(12,'moco_en_heces','Moco en heces','sintoma');
INSERT INTO "sintoma" VALUES(13,'esfuerzo_defecar','Esfuerzo defecar','sintoma');
INSERT INTO "sintoma" VALUES(14,'inapetencia','Pérdida de apetito','sintoma');
INSERT INTO "sintoma" VALUES(15,'vomitos_repetidos','Vómitos repetidos','sintoma');
INSERT INTO "sintoma" VALUES(16,'ingestion_objeto','Ingestión objeto','antecedente');
INSERT INTO "sintoma" VALUES(17,'regurgitacion_alimento_sin_digerir','Regurgitación alimento sin digerir','sintoma');
INSERT INTO "sintoma" VALUES(18,'heces_voluminosas','Heces voluminosas','sintoma');
INSERT INTO "sintoma" VALUES(19,'apetito_aumentado','Apetito aumentado','sintoma');
INSERT INTO "sintoma" VALUES(20,'diarrea_recurrente','Diarrea recurrente','sintoma');
INSERT INTO "sintoma" VALUES(21,'sintomas_asociados_alimento','Síntomas asociados alimento','antecedente');
INSERT INTO "sintoma" VALUES(22,'desparasitado_recientemente','Fue desparasitado recientemente','antecedente');
INSERT INTO "sintoma" VALUES(23,'ictericia','Ictericia','sintoma');
INSERT INTO "sintoma" VALUES(24,'heces_duras','Heces duras','sintoma');
INSERT INTO "sintoma" VALUES(25,'frecuencia_defecacion_disminuida','Frecuencia defecación disminuida','sintoma');
INSERT INTO "sintoma" VALUES(26,'mal_aliento','Mal aliento','sintoma');
INSERT INTO "sintoma" VALUES(27,'sarro_visible','Sarro visible','sintoma');
INSERT INTO "sintoma" VALUES(28,'encias_inflamadas','Encías inflamadas','sintoma');
INSERT INTO "sintoma" VALUES(29,'tos_persistente','Tos persistente','sintoma');
INSERT INTO "sintoma" VALUES(30,'contacto_con_perros','Ha tenido contacto con otros perros','antecedente');
INSERT INTO "sintoma" VALUES(31,'tos','Tos','sintoma');
INSERT INTO "sintoma" VALUES(32,'fiebre','Fiebre','sintoma');
INSERT INTO "sintoma" VALUES(33,'dificultad_respiratoria','Dificultad respiratoria','sintoma');
INSERT INTO "sintoma" VALUES(34,'picazon_intensa','Picazón intensa','sintoma');
INSERT INTO "sintoma" VALUES(35,'costras_orejas','Costras orejas','sintoma');
INSERT INTO "sintoma" VALUES(36,'lesiones_codos','Lesiones codos','sintoma');
INSERT INTO "sintoma" VALUES(37,'picazon','Picazón','sintoma');
INSERT INTO "sintoma" VALUES(38,'pulgas_visibles','Pulgas visibles','sintoma');
INSERT INTO "sintoma" VALUES(39,'picazon_recurrente','Picazón recurrente','sintoma');
INSERT INTO "sintoma" VALUES(40,'afectacion_patas','Afectación patas','sintoma');
INSERT INTO "sintoma" VALUES(41,'sintomas_estacionales','Síntomas estacionales','antecedente');
INSERT INTO "sintoma" VALUES(42,'piel_enrojecida','Piel enrojecida','sintoma');
INSERT INTO "sintoma" VALUES(43,'irritacion_recurrente','Irritación recurrente','sintoma');
INSERT INTO "sintoma" VALUES(44,'sed_aumentada','Sed aumentada','sintoma');
INSERT INTO "sintoma" VALUES(45,'miccion_aumentada','Micción aumentada','sintoma');
INSERT INTO "sintoma" VALUES(46,'sacude_cabeza','Sacude cabeza','sintoma');
INSERT INTO "sintoma" VALUES(47,'rascado_orejas','Rascado orejas','sintoma');
INSERT INTO "sintoma" VALUES(48,'secrecion_oido','Secreción oído','sintoma');
INSERT INTO "sintoma" VALUES(49,'exposicion_agua_contaminada_o_roedores','Exposición agua contaminada o roedores','antecedente');
INSERT INTO "sintoma" VALUES(50,'secrecion_ocular','Secreción ocular','sintoma');
INSERT INTO "sintoma" VALUES(51,'secrecion_nasal','Secreción nasal','sintoma');
INSERT INTO "sintoma" VALUES(52,'signos_neurologicos','Signos neurológicos','sintoma');
INSERT INTO "sintoma" VALUES(53,'colapso','Colapso','sintoma');
INSERT INTO "sintoma" VALUES(54,'convulsiones','Convulsiones','sintoma');
INSERT INTO "sintoma" VALUES(55,'decaimiento','Decaimiento','sintoma');
INSERT INTO "sintoma" VALUES(56,'vacunado_panleucopenia','Vacunado contra panleucopenia','antecedente');
INSERT INTO "sintoma" VALUES(57,'cambio_alimento_o_ingesta_inusual','Cambio alimento o ingesta inusual','antecedente');
INSERT INTO "sintoma" VALUES(58,'ulceras_orales','Úlceras orales','sintoma');
INSERT INTO "sintoma" VALUES(59,'estornudos','Estornudos','sintoma');
INSERT INTO "sintoma" VALUES(60,'tos_recurrente','Tos recurrente','sintoma');
INSERT INTO "sintoma" VALUES(61,'silbidos_respiratorios','Silbidos respiratorios','sintoma');
INSERT INTO "sintoma" VALUES(62,'costras_cuello_o_base_cola','Costras cuello o base cola','sintoma');
INSERT INTO "sintoma" VALUES(63,'perdida_pelo','Pérdida pelo','sintoma');
INSERT INTO "sintoma" VALUES(64,'lesiones_recurrentes','Lesiones recurrentes','sintoma');
INSERT INTO "sintoma" VALUES(65,'lesiones_cara','Lesiones cara','sintoma');
INSERT INTO "sintoma" VALUES(66,'inquietud','Inquietud','sintoma');
INSERT INTO "sintoma" VALUES(67,'edad_adulta_o_avanzada','Es un animal adulto o de edad avanzada','antecedente');
INSERT INTO "sintoma" VALUES(68,'babeo','Babeo','sintoma');
INSERT INTO "sintoma" VALUES(69,'dolor_al_comer','Dolor al comer','sintoma');
INSERT INTO "sintoma" VALUES(70,'encias_muy_inflamadas','Encías muy inflamadas','sintoma');
INSERT INTO "sintoma" VALUES(71,'esfuerzo_orinar','Esfuerzo orinar','sintoma');
INSERT INTO "sintoma" VALUES(72,'orina_nula_o_gotas','Orina nada o solo gotas','sintoma');
INSERT INTO "sintoma" VALUES(73,'miccion_frecuente','Micción frecuente','sintoma');
INSERT INTO "sintoma" VALUES(74,'dolor_al_orinar','Dolor al orinar','sintoma');
INSERT INTO "sintoma" VALUES(75,'todavia_expulsa_orina','Todavía expulsa orina','sintoma');
INSERT INTO "sintoma" VALUES(76,'orina_fuera_arenero','Orina fuera arenero','sintoma');
CREATE TABLE usuario (
  id_usuario    INTEGER PRIMARY KEY AUTOINCREMENT,
  id_rol        INTEGER NOT NULL REFERENCES rol(id_rol),
  nombre        VARCHAR(100) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  telefono      VARCHAR(20),
  edad          INTEGER CHECK (edad IS NULL OR edad >= 0),
  password_hash VARCHAR(255) NOT NULL,
  activo        INTEGER NOT NULL DEFAULT 1);
INSERT INTO "usuario" VALUES(1,3,'Administrador','admin@sistemaexperto.co',NULL,NULL,'scrypt:32768:8:1$FI0p8Clrb3aezJ8A$0c020baa1a19dcf4a6f25680064c44e56026eacd8b0ce82a7397fef8c2845983de76c319ef30f32377ae60ff45eb855c4b7d4540ad2758c660f0958fc299e06e',1);
INSERT INTO "usuario" VALUES(2,2,'Veterinaria Experta','experto@sistemaexperto.co',NULL,NULL,'scrypt:32768:8:1$SXbcvd1Wn6deCGVs$31e0589ff0a40d06522e1ed72c3c95f9b7145f7e2e65c2f39115871303853b35d037d79a987f1e3a2cb7e8fbb9f4e9e6f82e44d5ce338d067633fa481ab97676',1);
INSERT INTO "usuario" VALUES(3,1,'Consultante Demo','consultante@sistemaexperto.co',NULL,NULL,'scrypt:32768:8:1$et4nSzgRncarZJaS$4dc520e475ad9c0fa87df09d5fc2be2459e6dcaf8713d93843cbaacfe41cdbbeccd2d0ae69bccd29d89de3c111f11dd2dd56d131fb24e2eb6b72bc10dc5f44d8',1);
CREATE INDEX ix_enf_esp_cat ON enfermedad(id_especie, id_categoria);
CREATE INDEX ix_cond_regla  ON regla_condicion(id_regla);
CREATE INDEX ix_cons_user   ON consulta(id_usuario, fecha);
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('especie',2);
INSERT INTO "sqlite_sequence" VALUES('categoria',9);
INSERT INTO "sqlite_sequence" VALUES('sintoma',76);
INSERT INTO "sqlite_sequence" VALUES('enfermedad',45);
INSERT INTO "sqlite_sequence" VALUES('regla',45);
INSERT INTO "sqlite_sequence" VALUES('regla_condicion',133);
INSERT INTO "sqlite_sequence" VALUES('rol',3);
INSERT INTO "sqlite_sequence" VALUES('usuario',3);
INSERT INTO "sqlite_sequence" VALUES('animal',1);
INSERT INTO "sqlite_sequence" VALUES('consulta',3);
COMMIT;