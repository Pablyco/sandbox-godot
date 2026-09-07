# Assets Guide - Auto-Battler (Hello Kitty)

## CAMBIO IMPORTANTE - Scope reducido de arte
Para ahorrarte tiempo (producción de 3 días), cada personaje necesita SOLO:

### Por personaje (2 archivos):
1. **`<id>_idle.png`** - UN sprite estático (32x32 o 64x64 px). Esta es la imagen base del personaje.
2. **`<id>_ability.png`** - UN sprite sheet (3-4 frames) SOLO para la habilidad especial.

TODAS las demás animaciones (idle bob, ataque, recibir daño, muerte, movimiento, knockback, etc.)
se hacen con **tweens en código** sobre el sprite estático. No necesitás frames para esas.

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

### Sprites de habilidad (sprite sheets de 3-4 frames cada uno):
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
Los sprites se cargan desde `assets/sprites/<id>_idle.png`.
El tint de color por personaje se aplica EN CÓDIGO para estados especiales
(rage = naranja, demon = rojo, etc.), así que NO necesitás versiones tintadas.

## UI Elements
- **btn_normal.png** - Botón normal
- **btn_hover.png** - Botón hover
- **btn_pressed.png** - Botón presionado
- **health_bar_bg.png** - Fondo de barra de vida
- **health_bar_fill.png** - Relleno de barra de vida
- **ability_bar_bg.png** - Fondo de barra de cooldown
- **ability_bar_fill.png** - Relleno de barra de cooldown

## Partículas / Efectos (opcional, prioridad baja)
- **hit_spark.png** - Chispa de impacto
- **crit_spark.png** - Chispa de crítico (más grande)
- **heart.png** - Corazón para encanto de My Melody
- **zzz.png** - Burbuja de sueño para Gudetama

## Fondos
- **battle_bg.png** - Fondo de arena de batalla (1920x1080)
- **menu_bg.png** - Fondo del menú principal

## Notas:
- Formato PNG con transparencia
- Colores vibrantes (estilo cartoon)
- Sprites legibles a 32x32 px
- Las habilidades especiales las anima el usuario a mano en Godot
