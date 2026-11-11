import os, re
from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, session, flash, abort
import dao, engine

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'cambiar-en-produccion')
ROLES_EXPERTO = ('Experto', 'Administrador')

def conectar(): return dao.Conexion()
def req_rol(*roles):
    def deco(f):
        @wraps(f)
        def w(*a, **k):
            if 'u' not in session: return redirect(url_for('login'))
            if roles and session['u']['rol'] not in roles: abort(403)
            return f(*a, **k)
        return w
    return deco

@app.route('/')
def index(): return redirect(url_for('nueva_consulta' if 'u' in session else 'login'))

@app.route('/registro', methods=['GET', 'POST'])
def registro():
    if request.method == 'POST':
        f = request.form; db = conectar()
        try:
            if len(f['password']) < 8: raise ValueError('La contraseña debe tener mínimo 8 caracteres.')
            dao.UsuarioDAO(db).crear(f['nombre'].strip(), f['email'].strip(), f['password'], f.get('telefono'), f.get('edad') or None)
            flash('Registro exitoso. Ingresa con tu correo.', 'ok'); return redirect(url_for('login'))
        except Exception as e:
            flash('No se pudo registrar: ' + ('correo ya registrado' if 'UNIQUE' in str(e) else str(e)), 'err')
        finally: db.close()
    return render_template('registro.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        db = conectar(); u = dao.UsuarioDAO(db).autenticar(request.form['email'], request.form['password']); db.close()
        if u:
            session['u'] = dict(id=u['id_usuario'], nombre=u['nombre'], rol=u['rol']); return redirect(url_for('index'))
        flash('Credenciales inválidas.', 'err')
    return render_template('login.html')

@app.route('/logout')
def logout(): session.clear(); return redirect(url_for('login'))

@app.route('/animales', methods=['GET', 'POST'])
@req_rol()
def animales():
    db = conectar(); k = dao.ConocimientoDAO(db); a = dao.AnimalDAO(db)
    if request.method == 'POST':
        f = request.form
        a.crear(session['u']['id'], int(f['id_especie']), f['nombre'].strip(), f.get('raza'), f.get('edad') or None, f.get('sexo') or None)
        flash('Animal registrado.', 'ok')
    r = render_template('animales.html', animales=a.de_usuario(session['u']['id']), especies=k.especies()); db.close(); return r

@app.route('/consulta/nueva', methods=['GET', 'POST'])
@req_rol()
def nueva_consulta():
    db = conectar(); a = dao.AnimalDAO(db).de_usuario(session['u']['id'])
    if request.method == 'POST':
        an = dao.AnimalDAO(db).obtener(int(request.form['id_animal']), session['u']['id']); db.close()
        if not an: abort(404)
        return redirect(url_for('preguntas', id_animal=an['id_animal'], id_categoria=int(request.form['id_categoria'])))
    cats = {x['nombre']: dao.ConocimientoDAO(db).categorias(x['nombre']) for x in dao.ConocimientoDAO(db).especies()}
    db.close(); return render_template('nueva_consulta.html', animales=a, cats=cats)

@app.route('/consulta/preguntas/<int:id_animal>/<int:id_categoria>', methods=['GET', 'POST'])
@req_rol()
def preguntas(id_animal, id_categoria):
    db = conectar(); k = dao.ConocimientoDAO(db)
    an = dao.AnimalDAO(db).obtener(id_animal, session['u']['id'])
    if not an: db.close(); abort(404)
    sint = k.sintomas_de(an['especie'], id_categoria)
    if request.method == 'POST':
        resp = {s['codigo']: request.form.get(s['codigo'], 'nose') for s in sint}
        if sum(1 for v in resp.values() if v == 'si') < 1:                       # RF07: validación mínima
            flash('Indica al menos un síntoma o dato presente para evaluar.', 'err')
        else:
            inf = engine.inferir(k.reglas_activas(an['especie'], id_categoria), resp)
            idc = dao.ConsultaDAO(db).guardar(session['u']['id'], id_animal, id_categoria or None, resp, inf, {s['codigo']: s['id_sintoma'] for s in sint})
            db.close(); return redirect(url_for('resultado', id_consulta=idc))
    r = render_template('preguntas.html', animal=an, sintomas=sint); db.close(); return r

@app.route('/consulta/<int:id_consulta>')
@req_rol()
def resultado(id_consulta):
    db = conectar(); c = dao.ConsultaDAO(db).detalle(id_consulta, session['u']['id'])
    if not c: db.close(); abort(404)
    for r in c['resultados']: r['condiciones'] = dao.ConocimientoDAO(db).condiciones(r['id_regla'])
    db.close(); return render_template('resultado.html', c=c)

@app.route('/historial')
@req_rol()
def historial():
    db = conectar(); h = dao.ConsultaDAO(db).historial(session['u']['id']); db.close()
    return render_template('historial.html', h=h)

@app.route('/admin/conocimiento', methods=['GET', 'POST'])
@req_rol(*ROLES_EXPERTO)
def conocimiento():
    db = conectar(); k = dao.ConocimientoDAO(db); au = dao.AuditoriaDAO(db); uid = session['u']['id']
    if request.method == 'POST':
        f = request.form; acc = f['accion']
        if acc == 'nueva':
            conds = []
            for linea in f['condiciones'].splitlines():
                m = re.match(r'^\s*([a-z0-9_]+)\s*=\s*(si|no)\s*(?::\s*(\d+))?\s*$', linea)
                if m: conds.append((m.group(1), m.group(2), int(m.group(3) or len(conds) + 2)))
            if not conds: flash('Condiciones inválidas. Formato: sintoma=si (una por línea).', 'err')
            else:
                try:
                    idr = k.crear_enfermedad_regla(int(f['id_especie']), int(f['id_categoria']), f['nombre'], f['nivel'], f['diagnostico'],
                                                   f['recomendacion'], float(f['cf']), conds)
                    au.registrar(uid, 'regla', idr, 'crear', f['nombre']); flash('Regla creada (pendiente de validación).', 'ok')
                except Exception as e: flash('Error: ' + str(e), 'err')
        else:
            idr = int(f['id_regla'])
            if acc in ('validada', 'rechazada', 'pendiente'): k.estado(idr, acc)
            elif acc == 'alternar': k.alternar_activa(idr)
            elif acc == 'eliminar': k.eliminar_regla(idr)
            au.registrar(uid, 'regla', idr, acc)
    ctx = dict(reglas=k.listar_reglas(), especies=k.especies(), cats=db.q('SELECT * FROM categoria'), log=au.ultimos())
    r = render_template('conocimiento.html', **ctx); db.close(); return r

@app.route('/admin/usuarios', methods=['GET', 'POST'])
@req_rol('Administrador')
def usuarios():
    db = conectar(); u = dao.UsuarioDAO(db)
    if request.method == 'POST':
        if request.form['accion'] == 'rol': u.cambiar_rol(int(request.form['id']), int(request.form['id_rol']))
        else: u.alternar_activo(int(request.form['id']))
    r = render_template('usuarios.html', usuarios=u.listar(), roles=u.roles()); db.close(); return r

if __name__ == '__main__':
    if not os.path.exists(dao.DB):
        import build_db; build_db.build()
    app.run(debug=False, host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
