-- C1. Gránulos de conocimiento (condiciones) de UNA hipótesis: Parvovirosis canina
SELECT e.nombre AS hipotesis, r.id_regla, s.etiqueta AS granulo, rc.valor_esperado AS valor, rc.grupo
FROM enfermedad e JOIN regla r USING(id_enfermedad) JOIN regla_condicion rc USING(id_regla) JOIN sintoma s USING(id_sintoma)
WHERE e.nombre = 'Parvovirosis canina' ORDER BY rc.grupo, rc.id_condicion;

-- C2. Número de gránulos por hipótesis (perro, sistema digestivo)
SELECT e.nombre AS hipotesis, r.cf, COUNT(rc.id_condicion) AS n_granulos, e.nivel_atencion
FROM enfermedad e JOIN especie sp USING(id_especie) JOIN categoria c USING(id_categoria)
JOIN regla r USING(id_enfermedad) JOIN regla_condicion rc USING(id_regla)
WHERE sp.nombre = 'Perro' AND c.nombre = 'Digestivo' GROUP BY r.id_regla ORDER BY r.id_regla;

-- C3. Hipótesis que comparten un mismo gránulo (diagnóstico diferencial): diarrea = sí en perros
SELECT e.nombre AS hipotesis, r.cf FROM regla_condicion rc JOIN sintoma s USING(id_sintoma) JOIN regla r USING(id_regla)
JOIN enfermedad e USING(id_enfermedad) JOIN especie sp USING(id_especie)
WHERE s.codigo = 'diarrea' AND rc.valor_esperado = 'si' AND sp.nombre = 'Perro' ORDER BY r.cf DESC;

-- C4. Gránulos de todas las hipótesis de urgencia, agrupados por hipótesis
SELECT sp.nombre AS especie, e.nombre AS hipotesis, GROUP_CONCAT(s.etiqueta || '=' || rc.valor_esperado, '; ') AS granulos
FROM enfermedad e JOIN especie sp USING(id_especie) JOIN regla r USING(id_enfermedad)
JOIN regla_condicion rc USING(id_regla) JOIN sintoma s USING(id_sintoma)
WHERE e.nivel_atencion = 'urgencia' GROUP BY r.id_regla ORDER BY sp.nombre, r.id_regla;

-- C5. Cobertura: hipótesis por especie y categoría
SELECT sp.nombre AS especie, c.nombre AS categoria, COUNT(*) AS n_hipotesis
FROM enfermedad e JOIN especie sp USING(id_especie) JOIN categoria c USING(id_categoria) GROUP BY sp.nombre, c.nombre ORDER BY 1, 2;
