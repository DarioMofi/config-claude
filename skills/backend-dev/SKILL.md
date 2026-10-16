---
name: backend-dev
description: Patrones de diseño de APIs, optimización de bases de datos y seguridad de backend. Úsalo cuando la tarea involucre diseñar o revisar endpoints, modelar/optimizar consultas de base de datos, migraciones, autenticación/autorización, o cualquier decisión de arquitectura del lado del servidor.
---

# Backend: APIs, bases de datos y seguridad

## Cuándo usar este skill

Actívalo cuando la tarea pida:
- Diseñar o revisar endpoints (REST o GraphQL): forma de la respuesta, versionado, paginación, manejo de errores.
- Optimizar consultas o esquema de base de datos: índices, N+1, migraciones.
- Implementar o revisar autenticación/autorización, validación de entrada, o manejo de secretos.
- Decisiones de arquitectura de servidor que no son específicamente de diseño de módulos (para eso, `mattpocock-skills:codebase-design`) ni de UI (para eso, las skills de diseño).

## Diseño de APIs

**Forma de la respuesta — consistencia por encima de preferencia personal:**
- Un único formato de envoltura para éxito y error en todo el API (ej. `{ data, error, meta }`), no un formato distinto por endpoint.
- Errores con código de máquina estable (`"error_code": "invalid_email"`) además del mensaje legible — el código es lo que el cliente puede usar para lógica condicional, el mensaje puede cambiar de redacción sin romper nada.

**Paginación** — nunca devuelvas una colección sin límite. Cursor-based (`?after=<cursor>`) para colecciones que crecen o cambian con escrituras concurrentes; offset-based (`?page=`/`?offset=`) solo si el dataset es pequeño y estable.

**Idempotencia** — cualquier endpoint que cree un recurso con efecto financiero o irreversible (pagos, envíos de notificación) debe aceptar una idempotency key del cliente y devolver el mismo resultado si se reintenta con la misma key, en vez de crear un duplicado.

**Versionado** — versiona por necesidad real de romper compatibilidad, no por defecto (`/v1/` desde el día uno "por si acaso" es especulativo). Cuando sí rompas compatibilidad, mantén la versión anterior viva con un plazo de deprecación anunciado, no la apagues de golpe.

**Errores** — un error 500 nunca debe filtrar detalles internos (stack trace, nombre de tabla, ruta de archivo) al cliente; loggea el detalle del lado del servidor, devuelve un mensaje genérico + un ID de correlación para rastrearlo en logs.

## Optimización de base de datos

Con PostgreSQL (incluido Supabase), las reglas de índices, N+1, pooling de conexiones, locks y RLS viven en el skill `supabase:supabase-postgres-best-practices` — cárgalo antes de tocar esquema o consultas, no las dupliques aquí. Para la plataforma Supabase (CLI, MCP, auth, migraciones declarativas), el skill `supabase:supabase`. Lo que sigue complementa esos skills.

**Índices** — cuidado con sobre-indexar: cada índice tiene costo de escritura — no repliques un índice por columna "por si acaso" en tablas con escritura pesada.

**N+1 con ORM** — fuera de SQL directo, el arreglo suele ser el eager-loading del ORM (`include`/`select_related`/`with`, según el stack).

**Migraciones:**
- Nunca agregues una columna `NOT NULL` sin `DEFAULT` a una tabla con filas existentes sin antes hacer backfill — bloquea la tabla o falla, según el motor.
- En tablas grandes, evita locks de escritura largos: agrega el índice con la variante *concurrente* del motor (ej. `CREATE INDEX CONCURRENTLY` en Postgres) en vez de la versión que bloquea la tabla completa.
- Toda migración debe ser reversible o, si no lo es (ej. borrar una columna), documentar explícitamente que no lo es y por qué es aceptable.

### Cruce con `gis-exp`

Cuando la base de datos es PostgreSQL con **PostGIS**, las reglas de índice espacial (`GIST`) y de reproyección antes de calcular área/distancia viven en el skill `gis-exp` — no las dupliques aquí. Este skill cubre índices/consultas relacionales normales; `gis-exp` cubre la parte espacial.

## Seguridad de backend

- **Validación de entrada** en la frontera del sistema (donde entra el request), no confiar en que el cliente ya validó — nunca. Rechaza temprano con un error claro, no dejes que un dato mal formado se propague hasta la capa de base de datos.
- **Consultas parametrizadas siempre** — nunca construyas SQL concatenando strings con datos del usuario, sin excepción, aunque el dato "parezca" seguro (ej. un ID numérico que en realidad llega como string).
- **Autenticación vs. autorización son pasos distintos** — verificar quién es el usuario no implica que pueda hacer la acción sobre ese recurso específico. Cada endpoint que opera sobre un recurso propiedad de un usuario debe verificar la propiedad, no solo la sesión válida (el bug clásico: IDOR — Insecure Direct Object Reference).
- **Secretos** nunca en el código ni en el repo — variables de entorno o un secret manager; si un secreto se filtró alguna vez a git, rotarlo cuenta como la única mitigación real (reescribir historial no basta, el secreto ya pudo haberse visto).
- **Rate limiting** en cualquier endpoint de autenticación (login, reset de contraseña) y en cualquier endpoint costoso computacionalmente — sin esto, es fuerza bruta o abuso de recursos gratis.

## Stack de referencia

TypeScript/Node.js, Python, Go — el patrón aplica independiente del lenguaje; adapta la sintaxis, no el principio. PostgreSQL como base de datos relacional de referencia (ver cruce con `gis-exp` arriba para el caso espacial).
