class_name CharacterDatabase
extends RefCounted

static func get_all_characters() -> Array[CharacterData]:
	var characters: Array[CharacterData] = []

	# 1. Pompompurin - El Gordito Despistado
	# Tanque medio. Come pudding, se enoja, pega más fuerte.
	var pompompurin = CharacterData.new()
	pompompurin.id = "pompompurin"
	pompompurin.display_name = "Pompompurin"
	pompompurin.role = "Tanque Enojón"
	pompompurin.color = Color(1.0, 0.85, 0.2)
	pompompurin.max_health = 160.0
	pompompurin.attack_damage = 12.0
	pompompurin.attack_speed = 0.7
	pompompurin.crit_chance = 0.08
	pompompurin.hit_chance = 0.9
	pompompurin.ability_name = "¡ME COMÍ EL PUDDING!"
	pompompurin.ability_cooldown = 7.0
	pompompurin.ability_description = "Se come el pudin, se enoja y sube su daño un 80% por 5 segundos"
	characters.append(pompompurin)

	# 2. Pochacco - El Atleta
	# DPS veloz. Tira pelotas que stunnean.
	var pochacco = CharacterData.new()
	pochacco.id = "pochacco"
	pochacco.display_name = "Pochacco"
	pochacco.role = "Atleta Violento"
	pochacco.color = Color(0.95, 0.95, 0.95)
	pochacco.max_health = 90.0
	pochacco.attack_damage = 18.0
	pochacco.attack_speed = 1.3
	pochacco.crit_chance = 0.2
	pochacco.hit_chance = 0.9
	pochacco.ability_name = "¡OLÉ!"
	pochacco.ability_cooldown = 5.0
	pochacco.ability_description = "Tira una pelotaza al más cercano: daño x2 y aturde 1 segundo"
	characters.append(pochacco)

	# 3. BADTZ-MARU - El Chico Malo
	# Bruiser. Gira y hace daño en área.
	var badtz = CharacterData.new()
	badtz.id = "badtz"
	badtz.display_name = "BADTZ-MARU"
	badtz.role = "Rebelde Giratorio"
	badtz.color = Color(0.1, 0.1, 0.1)
	badtz.max_health = 130.0
	badtz.attack_damage = 16.0
	badtz.attack_speed = 0.9
	badtz.crit_chance = 0.12
	badtz.hit_chance = 0.88
	badtz.ability_name = "PATADA GIRATORIA"
	badtz.ability_cooldown = 6.0
	badtz.ability_description = "Gira como un tornado y hace daño a todos los cercanos"
	characters.append(badtz)

	# 4. Hangyodon - El Alcohólico
	# Support/Debuffer. Vomita cerveza, baja accuracy y daño.
	var hangyodon = CharacterData.new()
	hangyodon.id = "hangyodon"
	hangyodon.display_name = "Hangyodon"
	hangyodon.role = "Borracho Vomitín"
	hangyodon.color = Color(0.4, 0.7, 0.8)
	hangyodon.max_health = 110.0
	hangyodon.attack_damage = 10.0
	hangyodon.attack_speed = 0.75
	hangyodon.crit_chance = 0.05
	hangyodon.hit_chance = 0.85
	hangyodon.ability_name = "TRAGO AMARGO"
	hangyodon.ability_cooldown = 6.0
	hangyodon.ability_description = "Vomita cerveza a todos: daño + les baja el accuracy 40% por 4s"
	characters.append(hangyodon)

	# 5. My Melody - La Hermosa Glass Cannon
	# Glass cannon puro. Encanta, no recibe daño un rato.
	var melody = CharacterData.new()
	melody.id = "melody"
	melody.display_name = "My Melody"
	melody.role = "Femme Fatale"
	melody.color = Color(1.0, 0.6, 0.75)
	melody.max_health = 65.0
	melody.attack_damage = 28.0
	melody.attack_speed = 1.2
	melody.crit_chance = 0.25
	melody.hit_chance = 0.92
	melody.ability_name = "ENCANTO"
	melody.ability_cooldown = 8.0
	melody.ability_description = "Enamora al más cercano: no puede atacarla por 3 segundos"
	characters.append(melody)

	# 6. Gudetama - El Huevón
	# Tank/Support. Ralentiza a todos los cercanos.
	var gudetama = CharacterData.new()
	gudetama.id = "gudetama"
	gudetama.display_name = "Gudetama"
	gudetama.role = "Perezoso Cósmico"
	gudetama.color = Color(1.0, 0.95, 0.6)
	gudetama.max_health = 140.0
	gudetama.attack_damage = 8.0
	gudetama.attack_speed = 0.4
	gudetama.crit_chance = 0.05
	gudetama.hit_chance = 0.85
	gudetama.ability_name = "AGOTAMOS TODO"
	gudetama.ability_cooldown = 6.0
	gudetama.ability_description = "Su pereza es contagiosa: ralentiza a todos los cercanos 40% por 4s"
	characters.append(gudetama)

	# 7. Cinnamoroll - El Volador Kamikaze
	# DPS alto con autodaño. Vuela y se estrella.
	var cinnamoroll = CharacterData.new()
	cinnamoroll.id = "cinnamoroll"
	cinnamoroll.display_name = "Cinnamoroll"
	cinnamoroll.role = "Kamikaze celestial"
	cinnamoroll.color = Color(0.7, 0.85, 1.0)
	cinnamoroll.max_health = 75.0
	cinnamoroll.attack_damage = 22.0
	cinnamoroll.attack_speed = 1.1
	cinnamoroll.crit_chance = 0.18
	cinnamoroll.hit_chance = 0.9
	cinnamoroll.ability_name = "¡KAMIKAZE!"
	cinnamoroll.ability_cooldown = 5.0
	cinnamoroll.ability_description = "Vuela hacia el más cercano: daño x3 pero se autolesiona 20% HP"
	characters.append(cinnamoroll)

	# 8. Tuxedosam - El Tanque Gordo
	# Tanque puro. Salta y aplasta.
	var tuxedosam = CharacterData.new()
	tuxedosam.id = "tuxedosam"
	tuxedosam.display_name = "Tuxedosam"
	tuxedosam.role = "Tanque Abrumador"
	tuxedosam.color = Color(0.15, 0.15, 0.6)
	tuxedosam.max_health = 220.0
	tuxedosam.attack_damage = 14.0
	tuxedosam.attack_speed = 0.5
	tuxedosam.crit_chance = 0.08
	tuxedosam.hit_chance = 0.92
	tuxedosam.ability_name = "PLANCHAAAA"
	tuxedosam.ability_cooldown = 8.0
	tuxedosam.ability_description = "Salta y cae pesado: daño masivo en área a todos los cercanos"
	characters.append(tuxedosam)

	# 9. Kuromi - La Provocadora
	# Counter-attack specialist. Provoca y devuelve el doble.
	var kuromi = CharacterData.new()
	kuromi.id = "kuromi"
	kuromi.display_name = "Kuromi"
	kuromi.role = "Provocadora Psicópata"
	kuromi.color = Color(0.6, 0.1, 0.6)
	kuromi.max_health = 100.0
	kuromi.attack_damage = 18.0
	kuromi.attack_speed = 1.0
	kuromi.crit_chance = 0.15
	kuromi.hit_chance = 0.9
	kuromi.ability_name = "¿ME PEGÁS?"
	kuromi.ability_cooldown = 6.0
	kuromi.ability_description = "Se provoca: si la atacan, devuelve el doble de daño por 3 segundos"
	characters.append(kuromi)

	# 10. Hello Kitty - La Borra Demonio
	# All-rounder que explota. Se arranca el moño y se vuelve demonio.
	var kitty = CharacterData.new()
	kitty.id = "kitty"
	kitty.display_name = "Hello Kitty"
	kitty.role = "Demonio Cute"
	kitty.color = Color(1.0, 0.3, 0.3)
	kitty.max_health = 100.0
	kitty.attack_damage = 15.0
	kitty.attack_speed = 1.0
	kitty.crit_chance = 0.15
	kitty.hit_chance = 0.92
	kitty.ability_name = "MODO DEMONIO"
	kitty.ability_cooldown = 9.0
	kitty.ability_description = "Se arranca el moño: ojos rojos, combo de puñetazos hipervelocity a todos"
	characters.append(kitty)

	return characters

static func get_character_by_id(char_id: String) -> CharacterData:
	for c in get_all_characters():
		if c.id == char_id:
			return c
	return null
