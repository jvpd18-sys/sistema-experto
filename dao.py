"""Capa de acceso a datos (patrón DAO). Cada clase encapsula las consultas de una entidad."""
import os, sqlite3
from werkzeug.security import check_password_hash, generate_password_hash
DB = os.environ.get('SE_DB', os.path.join(os.path.dirname(os.path.abspath(__file__)), 'sistema_experto.db'))

class Conexion:
    def __init__(self, path=DB):
        self.cx = sqlite3.connect(path); self.cx.row_factory = sqlite3.Row
        self.cx.execute('PRAGMA foreign_keys = ON')
    def q(self, sql, p=()): return [dict(r) for r in self.cx.execute(sql, p).fetchall()]
    def one(self, sql, p=()): r = self.cx.execute(sql, p).fetchone(); return dict(r) if r else None
    def run(self, sql, p=()): cur = self.cx.execute(sql, p); self.cx.commit(); return cur.lastrowid
    def close(self): self.cx.close()

class UsuarioDAO:
    def __init__(self, db): self.db = db
    def crear(self, nombre, email, password, telefono=None, edad=None, id_rol=1):
        return self.db.run('INSERT INTO usuario(id_rol,nombre,email,telefono,edad,password_hash) VALUES (?,?,?,?,?,?)',
                           (id_rol, nombre, email.lower(), telefono, edad, generate_password_hash(password)))
    def autenticar(self, email, password):
        u = self.db.one('SELECT u.*, r.nombre AS rol FROM usuario u JOIN rol r USING(id_rol) WHERE email=? AND activo=1', (email.lower(),))
        return u if u and check_password_hash(u['password_hash'], password) else None
    def listar(self): return self.db.q('SELECT u.id_usuario,u.nombre,u.email,u.activo,r.nombre AS rol,u.id_rol FROM usuario u JOIN rol r USING(id_rol)')
    def roles(self): return self.db.q('SELECT * FROM rol')
    def cambiar_rol(self, id_u, id_rol): self.db.run('UPDATE usuario SET id_rol=? WHERE id_usuario=?', (id_rol, id_u))
    def alternar_activo(self, id_u): self.db.run('UPDATE usuario SET activo=1-activo WHERE id_usuario=?', (id_u,))

class AnimalDAO:
    def __init__(self, db): self.db = db
    def crear(self, id_u, id_especie, nombre, raza, edad, sexo):
        return self.db.run('INSERT INTO animal(id_usuario,id_especie,nombre,raza,edad_anios,sexo) VALUES (?,?,?,?,?,?)',
                           (id_u, id_especie, nombre, raza, edad, sexo))
    def de_usuario(self, id_u):
        return self.db.q('SELECT a.*, e.nombre AS especie FROM animal a JOIN especie e USING(id_especie) WHERE id_usuario=?', (id_u,))
    def obtener(self, id_a, id_u):
        return self.db.one('SELECT a.*, e.nombre AS especie FROM animal a JOIN especie e USING(id_especie) WHERE id_animal=? AND id_usuario=?', (id_a, id_u))

class ConocimientoDAO:
    def __init__(self, db): self.db = db
    def especies(self): return self.db.q('SELECT * FROM especie')
    def categorias(self, especie):
        return self.db.q('''SELECT DISTINCT c.id_categoria, c.nombre FROM categoria c JOIN enfermedad e USING(id_categoria)
                            JOIN especie s USING(id_especie) WHERE s.nombre=? AND c.nombre<>'Emergencia' ORDER BY c.nombre''', (especie,))
    def sintomas_de(self, especie, id_categoria):
        """Preguntas del cuestionario: síntomas de las reglas de la categoría + emergencia (RF05)."""
        if not id_categoria:      # consulta general: todos los síntomas de la especie
            return self.db.q('''SELECT s.id_sintoma, s.codigo, s.etiqueta, s.tipo, MIN(rc.id_condicion) AS ord
              FROM regla_condicion rc JOIN sintoma s USING(id_sintoma) JOIN regla r USING(id_regla)
              JOIN enfermedad e USING(id_enfermedad) JOIN especie sp USING(id_especie)
              WHERE sp.nombre=? AND r.activa=1 GROUP BY s.id_sintoma ORDER BY s.tipo DESC, s.etiqueta''', (especie,))
        return self.db.q('''SELECT s.id_sintoma, s.codigo, s.etiqueta, s.tipo, MIN(rc.id_condicion) AS ord
              FROM regla_condicion rc JOIN sintoma s USING(id_sintoma) JOIN regla r USING(id_regla)
              JOIN enfermedad e USING(id_enfermedad) JOIN especie sp USING(id_especie) JOIN categoria c USING(id_categoria)
              WHERE sp.nombre=? AND r.activa=1 AND (c.id_categoria=? OR c.nombre='Emergencia')
              GROUP BY s.id_sintoma ORDER BY s.tipo DESC, ord''', (especie, id_categoria))
    def reglas_activas(self, especie, id_categoria):
        rs = self.db.q('''SELECT r.*, e.nombre AS enfermedad, e.nivel_atencion, e.id_categoria, c.nombre AS categoria
              FROM regla r JOIN enfermedad e USING(id_enfermedad) JOIN especie sp USING(id_especie) JOIN categoria c USING(id_categoria)
              WHERE sp.nombre=? AND r.activa=1''', (especie,))     # todas las hipótesis de la especie compiten
        for r in rs: r['condiciones'] = self.condiciones(r['id_regla'])
        return rs
    def condiciones(self, id_regla):
        return self.db.q('''SELECT s.codigo, s.etiqueta, rc.valor_esperado, rc.grupo FROM regla_condicion rc
                            JOIN sintoma s USING(id_sintoma) WHERE id_regla=? ORDER BY rc.grupo, rc.id_condicion''', (id_regla,))
    def listar_reglas(self):
        return self.db.q('''SELECT r.id_regla, r.cf, r.estado_validacion, r.activa, e.nombre AS enfermedad, sp.nombre AS especie,
              c.nombre AS categoria, e.nivel_atencion FROM regla r JOIN enfermedad e USING(id_enfermedad)
              JOIN especie sp USING(id_especie) JOIN categoria c USING(id_categoria) ORDER BY r.id_regla''')
    def crear_enfermedad_regla(self, id_especie, id_categoria, nombre, nivel, diagnostico, recomendacion, cf, condiciones):
        """condiciones: lista (codigo_sintoma, valor, grupo). Los síntomas nuevos se crean en el catálogo."""
        ide = self.db.run('INSERT INTO enfermedad(id_especie,id_categoria,nombre,descripcion,nivel_atencion) VALUES (?,?,?,?,?)',
                          (id_especie, id_categoria, nombre, diagnostico, nivel))
        idr = self.db.run('INSERT INTO regla(id_enfermedad,diagnostico,recomendacion,cf) VALUES (?,?,?,?)', (ide, diagnostico, recomendacion, cf))
        for cod, val, g in condiciones:
            s = self.db.one('SELECT id_sintoma FROM sintoma WHERE codigo=?', (cod,))
            ids = s['id_sintoma'] if s else self.db.run('INSERT INTO sintoma(codigo,etiqueta,tipo) VALUES (?,?,?)', (cod, cod.replace('_', ' ').capitalize(), 'sintoma'))
            self.db.run('INSERT INTO regla_condicion(id_regla,id_sintoma,valor_esperado,grupo) VALUES (?,?,?,?)', (idr, ids, val, g))
        return idr
    def estado(self, id_regla, estado): self.db.run('UPDATE regla SET estado_validacion=? WHERE id_regla=?', (estado, id_regla))
    def alternar_activa(self, id_regla): self.db.run('UPDATE regla SET activa=1-activa WHERE id_regla=?', (id_regla,))
    def eliminar_regla(self, id_regla): self.db.run('DELETE FROM regla WHERE id_regla=?', (id_regla,))

class ConsultaDAO:
    def __init__(self, db): self.db = db
    def guardar(self, id_u, id_animal, id_cat, respuestas, inferencia, sintomas_ids):
        idc = self.db.run('INSERT INTO consulta(id_usuario,id_animal,id_categoria,prioridad) VALUES (?,?,?,?)',
                          (id_u, id_animal, id_cat, inferencia['prioridad']))
        for cod, val in respuestas.items():
            self.db.run('INSERT INTO consulta_respuesta VALUES (?,?,?)', (idc, sintomas_ids[cod], val))
        for r in inferencia['resultados']:
            self.db.run('INSERT INTO consulta_resultado VALUES (?,?,?,?,?,?)', (idc, r['id_regla'], r['tipo'], r['coincidencia'], r['cf_resultado'], r['probabilidad']))
        return idc
    def historial(self, id_u):
        return self.db.q('''SELECT c.id_consulta, c.fecha, c.prioridad, a.nombre AS animal, sp.nombre AS especie, COALESCE(ca.nombre,'General') AS categoria,
              (SELECT COUNT(*) FROM consulta_resultado WHERE id_consulta=c.id_consulta) AS n_resultados
              FROM consulta c JOIN animal a USING(id_animal) JOIN especie sp ON sp.id_especie=a.id_especie
              LEFT JOIN categoria ca ON ca.id_categoria=c.id_categoria WHERE c.id_usuario=? ORDER BY c.fecha DESC''', (id_u,))
    def detalle(self, id_c, id_u):
        c = self.db.one('''SELECT c.*, a.nombre AS animal, sp.nombre AS especie, COALESCE(ca.nombre,'General') AS categoria FROM consulta c
              JOIN animal a USING(id_animal) JOIN especie sp ON sp.id_especie=a.id_especie LEFT JOIN categoria ca ON ca.id_categoria=c.id_categoria
              WHERE c.id_consulta=? AND c.id_usuario=?''', (id_c, id_u))
        if not c: return None
        c['resultados'] = self.db.q('''SELECT cr.*, r.diagnostico, r.recomendacion, e.nombre AS enfermedad, e.nivel_atencion, r.id_regla
              FROM consulta_resultado cr JOIN regla r USING(id_regla) JOIN enfermedad e USING(id_enfermedad)
              WHERE id_consulta=? ORDER BY probabilidad DESC''', (id_c,))
        c['respuestas'] = self.db.q('SELECT s.etiqueta, cr.respuesta FROM consulta_respuesta cr JOIN sintoma s USING(id_sintoma) WHERE id_consulta=?', (id_c,))
        return c

class AuditoriaDAO:
    def __init__(self, db): self.db = db
    def registrar(self, id_u, entidad, id_ent, accion, detalle=''):
        self.db.run('INSERT INTO auditoria_conocimiento(id_usuario,entidad,id_entidad,accion,detalle) VALUES (?,?,?,?,?)', (id_u, entidad, id_ent, accion, detalle))
    def ultimos(self, n=30):
        return self.db.q('SELECT a.*, u.nombre AS usuario FROM auditoria_conocimiento a JOIN usuario u USING(id_usuario) ORDER BY id_auditoria DESC LIMIT ?', (n,))
