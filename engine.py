"""Motor de inferencia: encadenamiento hacia adelante con factores de certeza (CF) y ranking probabilístico.
Cada regla (hipótesis) se puntúa con la evidencia disponible; la puntuación se normaliza a porcentajes."""
MAX_OPCIONES = 6
MIN_RELEVANCIA = 0.33      # al menos 1/3 de las condiciones de la regla deben cumplirse
PENALIZA_CONTRADICCION = 0.5

def evaluar_regla(regla, resp):
    """Devuelve dict con grupos cumplidos / contradichos / total o None si no hay evidencia a favor.
    Mismo grupo = OR; grupos distintos = AND."""
    grupos = {}
    for c in regla['condiciones']:
        grupos.setdefault(c['grupo'], []).append(c)
    cumplidos = contradichos = 0
    for conds in grupos.values():
        if any(resp.get(c['codigo']) == c['valor_esperado'] for c in conds):
            cumplidos += 1
        elif all(resp.get(c['codigo']) in ('si', 'no') for c in conds):
            contradichos += 1
    total = len(grupos)
    if cumplidos == 0 or cumplidos / total < MIN_RELEVANCIA: return None
    return dict(cumplidos=cumplidos, contradichos=contradichos, total=total)

def inferir(reglas, respuestas):
    """reglas: lista de dicts (regla + enfermedad + condiciones). respuestas: {codigo: si|no|nose}.
    Puntaje = CF × coincidencia² × penalización por contradicciones. Probabilidad = puntaje / Σ puntajes (top N)."""
    cand = []
    for r in reglas:
        if not r['activa']: continue
        ev = evaluar_regla(r, respuestas)
        if not ev: continue
        coin = ev['cumplidos'] / ev['total']
        pen = 1 - PENALIZA_CONTRADICCION * ev['contradichos'] / ev['total']
        puntaje = r['cf'] * coin ** 2 * pen
        cand.append(dict(r, tipo='total' if ev['cumplidos'] == ev['total'] else 'parcial', coincidencia=round(coin, 2),
                         cumplidos=ev['cumplidos'], total_cond=ev['total'], contradichos=ev['contradichos'],
                         cf_resultado=round(r['cf'] * coin * pen, 2), puntaje=puntaje))
    cand.sort(key=lambda x: (-x['puntaje'], x['tipo'] != 'total'))
    top = cand[:MAX_OPCIONES]
    suma = sum(x['puntaje'] for x in top) or 1
    for x in top: x['probabilidad'] = round(100 * x['puntaje'] / suma, 1)
    # RG5: prioridad inmediata si una hipótesis de urgencia está bien respaldada (≥ 66 % de sus condiciones)
    urgente = any(x['nivel_atencion'] == 'urgencia' and x['coincidencia'] >= 0.66 and x['contradichos'] == 0 for x in top)
    return dict(resultados=top, prioridad='inmediata' if urgente else 'normal', indeterminado=not top)
