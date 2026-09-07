# Assets Guide - Auto-Battler (Hello Kitty) - VECTOR ART

## IMPORTANTE - Cambio a Vector Art
El arte ahora se hace en **vector art** (SVG). Scope reducido para producción de 3 días.

## Formato de entrega (mi recomendación)

### Sprites de personaje → **PNG a 512x512px** (render del vector)
- Dibujá el personaje en tu editor vectorial (Inkscape, Illustrator, Figma, Affinity Designer)
- Canvas **512x512px**, personaje centrado ocupando ~80% del canvas (dejar margen)
- Exportá como PNG con **fondo transparente**
- PNG a alta resolución te da control fino de tamaño en Godot y evita problemas de escala del SVG

### Fondos y UI grandes → **SVG directo** (Godot lo importa y rasteriza)
- Para fondos (1920x1080) y elementos de UI escalables, SVG directo es mejor porque
  podés ajustar la escala en la pestaña de importación sin regenerar el archivo
- Si preferís consistencia, exportá estas también a PNG de alta resolución

## Estructura de capas (MUY importante para animar)
Dentro de cada SVG, separá las partes en **capas/objetos** con nombres claros:
- `head`, `body`, `left_arm`, `right_arm`, `left_leg`, `right_leg`, `ears`, `accesorio`
- Así, si más adelante querés animar partes por separado con tweens o Noodle,
  podés extraerlas. Por ahora las animaciones se hacen con tweens sobre el sprite completo.

## Perfil / Look (estilo "toon" cómico)
- **Contorno grueso y oscuro** alrededor de cada forma (mira el estilo de cartoon moderno)
- **Colores planos** con 1-2 tonos de sombra y 1 de brillo
- Formas simples y exageradas: cabezas grandes, expresiones exageradas
- Es un juego cómico para YouTube: cuanto más caricaturizado, mejor

## Paleta por personaje (color base ya configurado en código)
Usá estos colores como base y derivá sombras/brillos:
| Personaje | Color base (RGB) |
|-----------|------------------|
| Pompompurin | Amarillo (1.0, 0.85, 0.2) |
| Pochacco | Blanco (0.95, 0.95, 0.95) |
| BADTZ-MARU | Negro (0.1, 0.1, 0.1) |
| Hangyodon | Azul (0.4, 0.7, 0.8) |
| My Melody | Rosa (1.0, 0.6, 0.75) |
| Gudetama | Crema (1.0, 0.95, 0.6) |
| Cinnamoroll | Azul cielo (0.7, 0.85, 1.0) |
| Tuxedosam | Azul oscuro (0.15, 0.15, 0.6) |
| Kuromi | Morado (0.6, 0.1, 0.6) |
| Hello Kitty | Rojo (1.0, 0.3, 0.3) |

## Archivo por personaje (SOLO 2):

### 1. `<id>_idle.png` - Sprite estático (512x512)
La imagen base del personaje en pose neutra de pie.

### 2. `<id>_ability.png` - Sprite sheet para la habilidad
**Sprite sheet horizontal de 3-4 frames** para la animación de la habilidad especial.
(Vos la animás a mano en Godot)

### Personajes:
1. **pompompurin_idle.png** - Perrito golden retriever con boina azul, gordito
2. **pochacco_idle.png** - Perrito blanco con orejas caídas, atlético
3. **badtz_idle.png** - Pingüino negro con mohawk, actitud de chico malo
4. **hangyodon_idle.png** - Pez azul solitario con botella de cerveza
5. **melody_idle.png** - Conejita blanca con capucha rosa, encantadora
6. **gudetama_idle.png** - Yema de huevo perezosa con cara triste
7. **cinnamoroll_idle.png** - Perrito blanco con orejas largas, chiquito
8. **tuxedosam_idle.png** - Pingüino gordo con moño
9. **kuromi_idle.png** - Conejita negra con cráneo en la frente
10. **kitty_idle.png** - Gata blanca con moño rojo

### Sprites de habilidad (3-4 frames cada uno):
- **pompompurin_ability.png** - Comiendo su pudin (pudin en mano)
- **pochacco_ability.png** - Tirando un pelotazo con fuerza
- **badtz_ability.png** - Posición de patada giratoria
- **hangyodon_ability.png** - Vomitando cerveza
- **melody_ability.png** - Lanzando un encanto de corazón
- **gudetama_ability.png** - Bostezando/rindiéndose con burbuja Zzz
- **cinnamoroll_ability.png** - Volando en picada de kamikaze
- **tuxedosam_ability.png** - Saltando con todo el peso cayendo
- **kuromi_ability.png** - Provocando con sonrisa malvada
- **kitty_ability.png** - Arrancándose el moño, ojos rojos demoníacos

## Sistema de sprites (importante)
- Los sprites se cargan desde `assets/sprites/<id>_idle.png`
- El tint por estados especiales (rage = naranja, demon = rojo) se aplica EN CÓDIGO,
  NO necesitás versiones tintadas de los sprites
- TODAS las animaciones (idle bob, ataque, recibir daño, muerte, movimiento, knockback)
  se hacen con **tweens en código** sobre el sprite estático. No necesitás frames para esas.

## UI Elements (vector, exportar PNG 64-128px o SVG)
- **btn_normal.png / btn_hover.png / btn_pressed.png** - Estados de botón
- **health_bar_bg.png / health_bar_fill.png** - Barra de vida
- **ability_bar_bg.png / ability_bar_fill.png** - Barra de cooldown
- **btn_primary.png** - Botón principal (Fight/Start) color destacado

## Partículas / Efectos (opcional, prioridad baja)
- **hit_spark.png** - Chispa de impacto
- **crit_spark.png** - Chispa de crítico (más grande)
- **heart.png** - Corazón para encanto de My Melody
- **zzz.png** - Burbuja de sueño para Gudetama

## Fondos (SVG o PNG 1920x1080)
- **battle_bg.png** - Fondo de arena de batalla
- **menu_bg.png** - Fondo del menú principal
- **versus_bg.png** - Fondo de la pantalla de selección

## Notas generales:
- Formato: **PNG 512x512 con transparencia para personajes**, SVG o PNG para fondos/UI
- Contorno grueso + colores vibrantes (estilo cartoon)
- Partes del cuerpo en capas separadas para futura animación
- Las habilidades especiales las anima el usuario a mano en Godot
