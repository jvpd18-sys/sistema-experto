# Sistema Experto Veterinario (perros y gatos)
Aplicación web Flask + SQLite. Cada consulta entrega hasta 6 hipótesis con probabilidad (%). Orientación preliminar: no reemplaza al médico veterinario.

## Ejecutar
    pip install -r requirements.txt
    python build_db.py      # (opcional) recrea la BD y carga el conocimiento
    python app.py           # http://localhost:5000

## Usuarios de prueba
admin@sistemaexperto.co / Admin123*  ·  experto@sistemaexperto.co / Experto123*  ·  consultante@sistemaexperto.co / Demo123*

## Estructura
app.py (controlador) · engine.py (motor de inferencia con CF) · dao.py (DAO) · schema.sql · build_db.py + knowledge.json (carga del conocimiento)
consultas_granulos.sql · sistema_experto_dump.sql · templates/ · static/
Antes de publicar: cambiar SECRET_KEY y contraseñas, añadir CSRF y límite de intentos.
