---
name: normativa-urb
description: Normativa de uso de suelo, planeación urbana y ordenamiento territorial bajo legislación mexicana. Úsalo cuando la tarea involucre dictámenes de uso de suelo, compatibilidad urbanística, programas de desarrollo urbano, ordenamiento ecológico o atlas de riesgo en México.
---

# Normativa urbana y territorial (México)

## Cuándo usar este skill

Actívalo cuando la tarea pida:
- Evaluar uso de suelo o compatibilidad urbanística de un predio/zona.
- Redactar o revisar un dictamen, informe o análisis territorial.
- Interpretar un Programa Municipal/Estatal de Desarrollo Urbano.
- Cruzar datos de ordenamiento ecológico o riesgo con un proyecto.

## Marco normativo federal

No todas las leyes federales aplican siempre — actívalas según lo que el predio/proyecto realmente toque, no las cites todas por rutina.

| Ley | Cuándo aplica |
|---|---|
| **LGAHOTDU** (Ley General de Asentamientos Humanos, Ordenamiento Territorial y Desarrollo Urbano) | Base federal de todo análisis de uso de suelo — siempre relevante como marco. |
| **LGEEPA** (Ley General del Equilibrio Ecológico y la Protección al Ambiente) | Base legal de los POEL/POER; aplica si el predio está en zona con criterios ecológicos o requiere MIA. |
| **Ley de Aguas Nacionales** | Si el predio colinda con un cuerpo de agua federal (río, lago, presa) — define la zona federal y franja de restricción. |
| **Ley General de Vida Silvestre** | Si el predio se superpone con un Área Natural Protegida (ANP) o hábitat de especies listadas. |
| **Ley General de Desarrollo Forestal Sustentable** | Si el predio tiene cobertura forestal y requiere cambio de uso de suelo forestal. |
| **Ley Agraria** | Si el predio es ejidal o comunal (ver sección de Tenencia de la tierra abajo). |
| **Ley General de Bienes Nacionales** | Si el predio colinda con zona federal marítimo-terrestre (ZOFEMAT) o bienes de dominio público federal. |
| **Ley de Caminos, Puentes y Autotransporte Federal** | Si el predio colinda con carretera federal — define el derecho de vía. |
| **Ley General de Protección Civil** | Base legal del Atlas de Riesgo — relevante siempre que el análisis toque riesgo. |
| **Ley Minera** | Solo si existe concesión minera vigente sobre el polígono. |

## Jerarquía territorial a citar (de mayor a menor)

1. **Ley estatal de asentamientos humanos / desarrollo urbano** correspondiente a la entidad del proyecto.
2. **Programa Municipal o Estatal de Desarrollo Urbano (PMDU/PDU)** vigente en el municipio — define usos de suelo, densidades, coeficientes (COS/CUS).
3. **Programa de Ordenamiento Ecológico Local o Regional (POEL/POER)** — cuando el predio esté en zona con criterios ecológicos.
4. **Atlas de Riesgo municipal/estatal** — cuando el análisis toque zonas de riesgo (inundación, deslizamiento, falla geológica).

## Regla crítica: vigencia normativa

Los programas de desarrollo urbano y las leyes estatales **cambian con cada administración** (municipal cada 3 años, estatal cada 6). Nunca asumas que una ley o programa citado en la conversación o en datos previos sigue vigente:
- Si la tarea depende de vigencia normativa, dilo explícitamente y recomienda verificar la fuente oficial antes de tomar una decisión con esa base.
- Si no tienes forma de verificar la fecha de la fuente, no la des por buena — señala la incertidumbre en vez de presentarla como dato firme.

## Estructura sugerida para un análisis/dictamen territorial

1. **Ubicación y contexto** — coordenadas, municipio, zona conforme al PMDU vigente.
2. **Uso de suelo asignado** — clave de zonificación, uso permitido/condicionado/prohibido según el programa.
3. **Normativa aplicable** — cita jerárquica (federal → estatal → municipal → ecológico) con la fecha de la fuente consultada.
4. **Restricciones adicionales** — riesgo, ordenamiento ecológico, servidumbres, derechos de vía.
5. **Conclusión** — compatibilidad del uso propuesto, condicionantes, siguiente paso recomendado (ver trámites reales abajo).

## Escala del análisis y trámites reales

El mapeo a un trámite concreto **solo aplica a escala predio/manzana**. A escala de plan municipal o estatal no existe un trámite equivalente — es nivel de política pública, no un caso individual. No fuerces esta tabla en un análisis de programa; úsala solo cuando la unidad de análisis sea un predio o manzana específica.

| Escenario (predio/manzana) | Trámite/documento asociado |
|---|---|
| Confirmar zonificación vigente de un predio | Constancia de Zonificación (municipal) |
| Determinar compatibilidad de un uso propuesto | Dictamen o Licencia de Uso de Suelo (municipal/estatal, según entidad) |
| Proyecto que excede umbrales de impacto vial/urbano (definidos por el reglamento local) | Estudio de Impacto Urbano (EIU) |
| Proyecto que toca criterios ecológicos (POEL/POER) o requiere cambio de uso de suelo forestal | Manifestación de Impacto Ambiental (MIA), estatal o federal según el caso |

## Tenencia de la tierra

**No la agregues por default.** Solo desarrolla esta sección cuando el escenario, la instrucción o el contexto lo amerite explícitamente — por ejemplo: predio rural, sin escrituras claras, mención de ejido/comunidad, o petición directa del usuario. Un dictamen urbano estándar sobre propiedad privada regularizada no la necesita.

Cuando sí aplique: si el predio es **ejidal o comunal**, no puede iniciarse un dictamen de uso de suelo formal ni un trámite de licencia sin antes resolver el régimen de propiedad — se requiere desincorporación del régimen ejidal y adopción del dominio pleno ante el **RAN (Registro Agrario Nacional)**, conforme a la Ley Agraria, antes de que aplique cualquier normativa urbana municipal/estatal sobre ese predio.

## COS/CUS: cálculo

- **COS** (Coeficiente de Ocupación del Suelo): % del área del predio que puede ocuparse en planta baja → `área de desplante = COS × área del predio`.
- **CUS** (Coeficiente de Utilización del Suelo): múltiplo del área del predio que puede construirse en total (todos los niveles) → `área construible total = CUS × área del predio`.
- **Niveles aproximados posibles** ≈ `CUS ÷ COS` (aproximado; el reglamento local puede fijar altura máxima independiente del coeficiente).

**Solo calcula con números reales.** Usa los coeficientes que aparezcan en el PMDU/PDU vigente, en un documento oficial que te compartan, o en la clave de zonificación que el usuario proporcione o que tú confirmes contra la fuente. Nunca inventes valores de ejemplo (ej. "COS 0.6, CUS 1.8") y los presentes como si aplicaran al predio en cuestión — si no tienes el dato real, pide el documento o la clave de zonificación en vez de asumir un valor típico.

## Casos límite frecuentes

- **Predio que cruza dos zonificaciones**: cada porción se rige por su propia zonificación — no promedies coeficientes entre ambas. Si tienes la geometría del predio y el polígono de zonificación en digital, usa `gis-exp` para partir el predio por la línea divisoria y calcular el área de cada porción.
- **Predio afectado por derecho de vía** (carretero, ferroviario, de líneas de transmisión): la franja de restricción reduce el área útil real. Resta esa franja del área del predio *antes* de aplicar COS/CUS, no después.
- **Asentamiento irregular** (uso real del suelo distinto al uso formal vigente en el PMDU): señala la discrepancia explícitamente en el dictamen — no asumas que el uso real está regularizado ni que se regularizará.

## Fuentes para verificar

| Fuente | Para qué sirve |
|---|---|
| DOF (Diario Oficial de la Federación) | Leyes y reglamentos federales |
| Periódico/Gaceta Oficial del estado | Leyes estatales y PMDU/PDU estatales |
| Gaceta/portal municipal | PDU municipal, licencias, constancias |
| RAN (Registro Agrario Nacional) | Tenencia de la tierra ejidal/comunal |
| SEDATU | Lineamientos y programas de desarrollo urbano y ordenamiento territorial |
| INEGI | Marco Geoestadístico Nacional, uso de suelo y vegetación |
| CONAGUA | Atlas Nacional de Riesgos, zonas federales de cuerpos de agua |
| Geoportal estatal/municipal de zonificación (varía por entidad) | Consulta digital de zonificación vigente — buscar el vigente por WebSearch, no asumir una URL fija |

## Terminología clave

- **COS/CUS** — Coeficiente de Ocupación del Suelo / Coeficiente de Utilización del Suelo (ver cálculo arriba).
- **Uso de suelo permitido/condicionado/prohibido** — las tres categorías típicas en un PMDU.
- **Densidad** — habitantes o viviendas por hectárea según zonificación.
- **Vialidad** — clasificación (primaria, secundaria, local) que afecta restricciones de uso.

## Conexión con `gis-exp`

Cuando la zonificación exista como capa digital (shapefile/GeoJSON del municipio o de un geoportal), el cruce predio↔zonificación debe hacerse como un **spatial join**, no leyendo el PMDU en PDF a mano: carga el predio y la capa de zonificación, cruza (`sjoin`/`ST_Intersects`), y lee la clave de zonificación resultante — ver la sección correspondiente en `gis-exp`. Para inspeccionar datos geoespaciales reales de forma aislada, usa el agente `gis-data-analyst`.
