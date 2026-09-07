class_name CharacterDatabase
extends RefCounted

static func get_all_characters() -> Array[CharacterData]:
	var characters: Array[CharacterData] = []

	# 1. Pompompurin - The Scatterbrained Chubby
	# Mid tank. Eats pudding, gets angry, hits harder.
	var pompompurin = CharacterData.new()
	pompompurin.id = "pompompurin"
	pompompurin.display_name = "Pompompurin"
	pompompurin.role = "Angry Chunky Boy"
	pompompurin.color = Color(1.0, 0.85, 0.2)
	pompompurin.max_health = 160.0
	pompompurin.attack_damage = 12.0
	pompompurin.attack_speed = 0.7
	pompompurin.crit_chance = 0.08
	pompompurin.hit_chance = 0.9
	pompompurin.ability_name = "I ATE MY PUDDING!"
	pompompurin.ability_cooldown = 7.0
	pompompurin.ability_description = "Eats his pudding, gets ANGRY: +80% damage for 5 seconds"
	pompompurin.move_speed = 90.0
	characters.append(pompompurin)

	# 2. Pochacco - The Athlete
	# Fast DPS. Throws balls that stun.
	var pochacco = CharacterData.new()
	pochacco.id = "pochacco"
	pochacco.display_name = "Pochacco"
	pochacco.role = "Violent Athlete"
	pochacco.color = Color(0.95, 0.95, 0.95)
	pochacco.max_health = 90.0
	pochacco.attack_damage = 18.0
	pochacco.attack_speed = 1.3
	pochacco.crit_chance = 0.2
	pochacco.hit_chance = 0.9
	pochacco.ability_name = "OLÉ!"
	pochacco.ability_cooldown = 5.0
	pochacco.ability_description = "Tosses a big ball at the closest enemy: x2 damage and 1s stun"
	pochacco.move_speed = 170.0
	characters.append(pochacco)

	# 3. BADTZ-MARU - The Bad Boy
	# Bruiser. Spins and deals AoE damage.
	var badtz = CharacterData.new()
	badtz.id = "badtz"
	badtz.display_name = "BADTZ-MARU"
	badtz.role = "Spinning Rebel"
	badtz.color = Color(0.1, 0.1, 0.1)
	badtz.max_health = 130.0
	badtz.attack_damage = 16.0
	badtz.attack_speed = 0.9
	badtz.crit_chance = 0.12
	badtz.hit_chance = 0.88
	badtz.ability_name = "SPIN KICK"
	badtz.ability_cooldown = 6.0
	badtz.ability_description = "Spins like a tornado, damaging all nearby enemies"
	badtz.move_speed = 110.0
	characters.append(badtz)

	# 4. Hangyodon - The Alcoholic
	# Support/Debuffer. Vomits beer, lowers accuracy and damage.
	var hangyodon = CharacterData.new()
	hangyodon.id = "hangyodon"
	hangyodon.display_name = "Hangyodon"
	hangyodon.role = "Sloppy Drunk"
	hangyodon.color = Color(0.4, 0.7, 0.8)
	hangyodon.max_health = 110.0
	hangyodon.attack_damage = 10.0
	hangyodon.attack_speed = 0.75
	hangyodon.crit_chance = 0.05
	hangyodon.hit_chance = 0.85
	hangyodon.ability_name = "BITTER DRINK"
	hangyodon.ability_cooldown = 6.0
	hangyodon.ability_description = "Vomits beer on everyone: damage + -40% accuracy for 4s"
	hangyodon.move_speed = 105.0
	characters.append(hangyodon)

	# 5. My Melody - The Beautiful Glass Cannon
	# Pure glass cannon. Charms, takes no damage for a while.
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
	melody.ability_name = "CHARM"
	melody.ability_cooldown = 8.0
	melody.ability_description = "Charms the closest enemy: it can't attack her for 3 seconds"
	melody.move_speed = 155.0
	characters.append(melody)

	# 6. Gudetama - The Lazy Egg
	# Tank/Support. Slows everyone nearby.
	var gudetama = CharacterData.new()
	gudetama.id = "gudetama"
	gudetama.display_name = "Gudetama"
	gudetama.role = "Cosmic Lazy Boy"
	gudetama.color = Color(1.0, 0.95, 0.6)
	gudetama.max_health = 140.0
	gudetama.attack_damage = 8.0
	gudetama.attack_speed = 0.4
	gudetama.crit_chance = 0.05
	gudetama.hit_chance = 0.85
	gudetama.ability_name = "NAPS TIME..."
	gudetama.ability_cooldown = 6.0
	gudetama.ability_description = "His laziness is contagious: slows all nearby enemies 40% for 4s"
	gudetama.move_speed = 60.0
	characters.append(gudetama)

	# 7. Cinnamoroll - The Kamikaze Flyer
	# High DPS with self-damage. Flies and crashes.
	var cinnamoroll = CharacterData.new()
	cinnamoroll.id = "cinnamoroll"
	cinnamoroll.display_name = "Cinnamoroll"
	cinnamoroll.role = "Heavenly Kamikaze"
	cinnamoroll.color = Color(0.7, 0.85, 1.0)
	cinnamoroll.max_health = 75.0
	cinnamoroll.attack_damage = 22.0
	cinnamoroll.attack_speed = 1.1
	cinnamoroll.crit_chance = 0.18
	cinnamoroll.hit_chance = 0.9
	cinnamoroll.ability_name = "KAMIKAZE!"
	cinnamoroll.ability_cooldown = 5.0
	cinnamoroll.ability_description = "Flies at the closest enemy: x3 damage but hurts himself 20% HP"
	cinnamoroll.move_speed = 190.0
	characters.append(cinnamoroll)

	# 8. Tuxedosam - The Fat Tank
	# Pure tank. Jumps and crushes.
	var tuxedosam = CharacterData.new()
	tuxedosam.id = "tuxedosam"
	tuxedosam.display_name = "Tuxedosam"
	tuxedosam.role = "Overwhelming Tank"
	tuxedosam.color = Color(0.15, 0.15, 0.6)
	tuxedosam.max_health = 220.0
	tuxedosam.attack_damage = 14.0
	tuxedosam.attack_speed = 0.5
	tuxedosam.crit_chance = 0.08
	tuxedosam.hit_chance = 0.92
	tuxedosam.ability_name = "PLANCHAAA!"
	tuxedosam.ability_cooldown = 8.0
	tuxedosam.ability_description = "Jumps and lands heavy: massive AoE damage to all nearby"
	tuxedosam.move_speed = 70.0
	characters.append(tuxedosam)

	# 9. Kuromi - The Provoker
	# Counter-attack specialist. Provokes and reflects double.
	var kuromi = CharacterData.new()
	kuromi.id = "kuromi"
	kuromi.display_name = "Kuromi"
	kuromi.role = "Psycho Provoker"
	kuromi.color = Color(0.6, 0.1, 0.6)
	kuromi.max_health = 100.0
	kuromi.attack_damage = 18.0
	kuromi.attack_speed = 1.0
	kuromi.crit_chance = 0.15
	kuromi.hit_chance = 0.9
	kuromi.ability_name = "HIT ME!?"
	kuromi.ability_cooldown = 6.0
	kuromi.ability_description = "Taunts enemies: if she is hit, reflects double damage for 3 seconds"
	kuromi.move_speed = 125.0
	characters.append(kuromi)

	# 10. Hello Kitty - The Cute Demon
	# All-rounder that explodes. Rips off her bow and becomes a demon.
	var kitty = CharacterData.new()
	kitty.id = "kitty"
	kitty.display_name = "Hello Kitty"
	kitty.role = "Cute Demon"
	kitty.color = Color(1.0, 0.3, 0.3)
	kitty.max_health = 100.0
	kitty.attack_damage = 15.0
	kitty.attack_speed = 1.0
	kitty.crit_chance = 0.15
	kitty.hit_chance = 0.92
	kitty.ability_name = "DEMON MODE"
	kitty.ability_cooldown = 9.0
	kitty.ability_description = "Rips off the bow: red eyes, hypervelocity punch combo on everyone"
	kitty.move_speed = 130.0
	characters.append(kitty)

	return characters

static func get_character_by_id(char_id: String) -> CharacterData:
	for c in get_all_characters():
		if c.id == char_id:
			return c
	return null
