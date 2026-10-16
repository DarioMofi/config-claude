---
description: Auditoría de arquitectura a nivel sistema (estructura, dependencias, flujo de datos, escalabilidad, seguridad, deuda técnica). Invocación manual únicamente — no compite con codebase-design ni improve-codebase-architecture.
argument-hint: "[eje opcional: dependencias | flujo de datos | escalabilidad | seguridad | deuda técnica]"
---

Audita la arquitectura del proyecto actual a **nivel sistema**, no a nivel de un módulo individual — para eso existen los skills `mattpocock-skills:codebase-design` (vocabulario de módulos "deep") e `mattpocock-skills:improve-codebase-architecture` (oportunidades puntuales de refactor). Este comando no los reemplaza ni compite con ellos; opera un nivel arriba.

Si el usuario pasó un foco en `$ARGUMENTS` (ej. "seguridad", "flujo de datos"), concéntrate en ese eje y trata el resto como contexto de apoyo. Si no pasó nada, cubre los 6 ejes.

## Ejes de análisis

1. **Estructura del sistema** — mapea los componentes principales, sus límites, y los puntos de entrada (APIs, colas, cron jobs, UI). Identifica qué patrón arquitectónico sigue el proyecto (monolito, microservicios, capas, hexagonal, etc.) aunque no esté declarado explícitamente.
2. **Arquitectura de dependencias** — examina el grafo de dependencias entre módulos/paquetes: acoplamiento excesivo, dependencias circulares, y qué tan arriesgadas son las dependencias externas (versión, mantenimiento, tamaño del blast radius si fallan).
3. **Flujo de datos** — traza cómo se mueve la información por el sistema: dónde vive el estado, quién es la fuente de verdad, y si hay estado duplicado o desincronizado entre capas.
4. **Escalabilidad y performance** — identifica cuellos de botella estructurales (no bugs puntuales de performance, eso es para `mattpocock-skills:diagnosing-bugs`) y límites de escalamiento: qué se rompe primero si el tráfico/datos crecen 10x.
5. **Arquitectura de seguridad** — fronteras de confianza (dónde termina el input no confiable y empieza el confiable), flujo de autenticación/autorización de punta a punta, y manejo de secretos a nivel de arquitectura (no de una línea de código puntual).
6. **Deuda técnica y extensibilidad** — qué decisiones estructurales actuales van a estorbar el próximo cambio grande, y qué tan caro sería revertirlas.

## Entrega

Para cada eje cubierto: hallazgos concretos con ubicación (archivo/módulo), por qué importa, y una recomendación accionable. Prioriza por severidad (crítico/alto/medio/bajo) al cierre. Si el volumen de recomendaciones amerita planearlo como trabajo de varias sesiones, sugiere usar el skill `mattpocock-skills:wayfinder` para convertirlo en tickets — no lo hagas tú directamente salvo que te lo pidan.
