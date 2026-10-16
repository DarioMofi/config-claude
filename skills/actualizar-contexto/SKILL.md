---
name: actualizar-contexto
description: Actualiza el CLAUDE.md de un proyecto para que una conversación nueva arranque ya con el contexto correcto. Úsalo cuando el usuario pida actualizar el contexto, el CLAUDE.md o "lo que sabes del proyecto", y también proponiéndolo tú cuando se acaba de cerrar un cambio estructural: el usuario dice que algo "ya funciona", "quedó listo", "va bien", "pasemos a otra cosa" o "abro otra conversación", o cuando termina una migración, un refactor, un cambio de arquitectura, de pipeline o de estructura de carpetas. Si el proyecto no tiene CLAUDE.md, créalo.
---

# Actualizar el contexto del proyecto

## Para qué sirve esto

`CLAUDE.md` es lo primero que se carga al abrir una sesión en un proyecto. Es lo
que permite que una conversación nueva no empiece de cero.

Eso tiene una consecuencia que gobierna todo lo demás: **cada línea del archivo
se paga en todas las sesiones futuras**. Una línea que no aporta no es neutral,
compite por atención con las que sí importan. Por eso este trabajo consiste
tanto en podar como en escribir, y por eso un `CLAUDE.md` que solo crece acaba
siendo peor que no tener ninguno.

El otro riesgo es peor todavía: un dato desactualizado. Si el archivo dice que
los datos están en `public/` y ya no es cierto, una sesión nueva lo va a creer y
va a trabajar sobre una premisa falsa. Preferible omitir algo que afirmarlo mal.

## Reunir qué cambió

No lo escribas de memoria ni solo desde la conversación. Contrasta:

- `git log --oneline -20` y `git status` para ver el movimiento reciente.
- `git log -1 --format=%cd -- CLAUDE.md` para saber desde cuándo no se toca, y
  `git diff --stat` desde ahí si el repo lo permite.
- La conversación actual, que es la única fuente del **porqué** de las
  decisiones. Git te dice qué cambió; solo la conversación te dice por qué se
  eligió eso y qué alternativa se descartó.

Si el proyecto no tiene git o el historial no ayuda, apóyate en la conversación
y verifica contra el sistema de archivos.

## El filtro: qué entra y qué no

Este es el corazón de la tarea. La prueba es sencilla: **¿alguien que abre el
repo y lee el código podría deducir esto solo?** Si la respuesta es sí, no va.

Entra, y esto primero de todo:

- **La intención del proyecto.** Hacia dónde va, qué es provisional y qué es
  definitivo, qué ya está comprometido con quien lo va a usar, qué falta por
  decidir. Es lo más valioso del archivo porque es lo único que no está en
  ninguna parte del repo: el código dice cómo están las cosas hoy, nunca si eso
  es un andamio o la versión final. Sin ello, una sesión nueva trata como
  desechable algo que va a producción, o al revés, y toma decisiones de diseño
  contra un futuro equivocado.

  Cuando el usuario mencione de pasada un plan —una migración pendiente, un
  módulo que viene, un compromiso con el cliente, un plazo—, recógelo aunque
  todavía no exista una línea de código. Y si de eso solo se sabe una parte,
  escríbela y marca lo que falta por definir; un hueco señalado vale, uno
  rellenado a ojo hace daño.

- Decisiones y su razón. Por qué una carpeta está donde está, por qué existe
  una separación entre dos módulos, qué se intentó antes y falló.
- Restricciones que no se ven en el código: límites de una librería, un formato
  que no se puede reproducir, una dependencia entre pasos que no es obvia.
- Trampas del entorno que ya costaron tiempo una vez. Si un bug tardó en
  encontrarse, describir la trampa ahorra que se repita.
- Flujos operativos que no están en `package.json` ni en un script: qué correr,
  en qué orden, qué borrar antes.
- Convenciones que no se deducen leyendo un archivo cualquiera.
- Invariantes que no hay que romper, con el motivo. «No volver a fusionar estos
  dos estados» vale mucho más si dice por qué se separaron.

No entra:

- Lo que se ve en el árbol de archivos o leyendo una función.
- Historial de cambios. Para eso está git.
- Narración de la sesión: «arreglamos X, luego Y, después Z». El archivo
  describe **cómo está el proyecto ahora**, no cómo llegó aquí.
- Cifras y detalles volátiles que van a envejecer en semanas. Si el dato importa
  y cambia, mejor decir dónde consultarlo que fijarlo.
- Lo que ya vive en el README, en `package.json` o en un doc del repo. Enlázalo
  en lugar de duplicarlo: dos copias divergen y luego nadie sabe cuál vale.

## Podar antes de escribir

Lee el `CLAUDE.md` que ya existe, entero, antes de tocarlo. Para cada afirmación
pregúntate si sigue siendo cierta después de los cambios. Lo que quedó obsoleto
se corrige o se borra, no se deja «por si acaso».

Es normal y sano que una actualización quite más líneas de las que agrega.

## Verificar antes de afirmar

Si vas a escribir que existe un archivo, una carpeta, un comando o una bandera,
compruébalo. Este archivo se va a creer sin cuestionarlo en sesiones futuras, así
que una afirmación equivocada aquí cuesta más que en cualquier otro lugar del
repo.

Vale lo mismo para lo que arrastres del archivo anterior: si lo conservas, lo
estás afirmando de nuevo.

## Tamaño

Apunta a que quepa de una sentada. Si pasa de unas 150 líneas, es señal de que
hay detalle que debería vivir en `docs/` con un enlace desde aquí, no de que
haga falta un archivo más largo.

## Cierre

Muestra al usuario un resumen corto de qué agregaste, qué quitaste y qué
corregiste, y por qué. No reescribas el archivo en silencio: es el documento que
gobierna todas las sesiones siguientes y el usuario tiene que reconocerlo como
suyo.

No hagas commit salvo que lo pidan.

## Cuándo proponerlo tú

Una skill no se dispara sola, así que el buen momento lo tienes que detectar. Se
nota cuando el usuario cierra un tema: dice que algo ya funciona, que pasa a otra
cosa, o que va a abrir otra conversación. Ese es el momento de decir algo breve
como «antes de seguir, ¿actualizamos el CLAUDE.md?», y seguir si acepta.

Propónlo solo cuando el cambio de verdad altera cómo se entiende el proyecto:
arquitectura, estructura de carpetas, un pipeline, una convención nueva, una
restricción descubierta. Después de un arreglo puntual o un cambio de estilo, no
hay nada que registrar y sugerirlo es ruido.

Si el usuario dice que no, no insistas. Una segunda sugerencia sobre el mismo
cambio molesta más de lo que ayuda.

## Si el proyecto no tiene CLAUDE.md

Créalo, con la misma vara: solo lo que no se deduce del código. Un archivo corto
y cierto sirve; uno largo y genérico —«este proyecto usa React, los componentes
van en componentes»— no aporta nada que no se vea abriendo la carpeta.

Un esqueleto razonable, siempre que cada sección tenga algo real que decir: qué
es el proyecto y en qué estado está, cómo se corre, las decisiones de
arquitectura con su porqué, las limitaciones conocidas, las convenciones y las
trampas del entorno. Si una sección quedaría vacía o genérica, quítala.
