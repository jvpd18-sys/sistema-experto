"""Crea la BD, carga el conocimiento del experto (knowledge.json) y los usuarios semilla."""
import json, os, sqlite3, sys
from werkzeug.security import generate_password_hash
HERE = os.path.dirname(os.path.abspath(__file__))

def build(db_path=os.path.join(HERE, 'sistema_experto.db'), kjson=os.path.join(HERE, 'knowledge.json')):
    if os.path.exists(db_path): os.remove(db_path)
    K = json.load(open(kjson, encoding='utf-8'))
    c = sqlite3.connect(db_path); c.executescript(open(os.path.join(HERE, 'schema.sql'), encoding='utf-8').read())
    c.executemany('INSERT INTO especie(nombre) VALUES (?)', [(e,) for e in K['especies']])
    cats = sorted({e['categoria'] for e in K['enfermedades']})
    c.executemany('INSERT INTO categoria(nombre) VALUES (?)', [(x,) for x in cats])
    c.executemany('INSERT INTO sintoma(codigo,etiqueta,tipo) VALUES (?,?,?)', [(s['codigo'], s['etiqueta'], s['tipo']) for s in K['sintomas']])
    esp = {n: i for i, n in c.execute('SELECT id_especie,nombre FROM especie')}
    cat = {n: i for i, n in c.execute('SELECT id_categoria,nombre FROM categoria')}
    sin = {n: i for i, n in c.execute('SELECT id_sintoma,codigo FROM sintoma')}
    for e in K['enfermedades']:
        c.execute('INSERT INTO enfermedad(id_enfermedad,id_especie,id_categoria,nombre,descripcion,nivel_atencion) VALUES (?,?,?,?,?,?)',
                  (e['id'], esp[e['especie']], cat[e['categoria']], e['nombre'], e['descripcion'], e['nivel']))
    for r in K['reglas']:
        c.execute('INSERT INTO regla(id_regla,id_enfermedad,diagnostico,recomendacion,cf) VALUES (?,?,?,?,?)',
                  (r['id'], r['enfermedad'], r['diagnostico'], r['recomendacion'], r['cf']))
        c.executemany('INSERT INTO regla_condicion(id_regla,id_sintoma,valor_esperado,grupo) VALUES (?,?,?,?)',
                      [(r['id'], sin[x['sintoma']], x['valor'], x['grupo']) for x in r['condiciones']])
    c.executemany('INSERT INTO rol(nombre,descripcion) VALUES (?,?)', [
        ('Consultante', 'Dueño del animal: registra animales y realiza consultas.'),
        ('Experto', 'Veterinario: valida y gestiona enfermedades, síntomas y reglas.'),
        ('Administrador', 'Gestiona usuarios y roles.')])
    for rol, nom, mail, pw in [(3, 'Administrador', 'admin@sistemaexperto.co', 'Admin123*'),
                               (2, 'Veterinaria Experta', 'experto@sistemaexperto.co', 'Experto123*'),
                               (1, 'Consultante Demo', 'consultante@sistemaexperto.co', 'Demo123*')]:
        c.execute('INSERT INTO usuario(id_rol,nombre,email,password_hash) VALUES (?,?,?,?)', (rol, nom, mail, generate_password_hash(pw)))
    c.commit(); c.close()

if __name__ == '__main__': build(); print('BD creada')
