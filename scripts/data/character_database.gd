class_name CharacterDatabase
extends RefCounted

static func get_all_characters() -> Array[CharacterData]:
	var characters: Array[CharacterData] = []

	var knight = CharacterData.new()
	knight.id = "knight"
	knight.display_name = "Caballero"
	knight.color = Color(0.2, 0.4, 0.8)
	knight.max_health = 150.0
	knight.attack_damage = 15.0
	knight.attack_speed = 0.8
	knight.crit_chance = 0.1
	knight.hit_chance = 0.95
	knight.ability_name = "Golpe Escudo"
	knight.ability_cooldown = 6.0
	knight.ability_description = "Bloquea el próximo ataque y contraataca"
	characters.append(knight)

	var ninja = CharacterData.new()
	ninja.id = "ninja"
	ninja.display_name = "Ninja"
	ninja.color = Color(0.1, 0.1, 0.1)
	ninja.max_health = 80.0
	ninja.attack_damage = 25.0
	ninja.attack_speed = 1.5
	ninja.crit_chance = 0.3
	ninja.hit_chance = 0.85
	ninja.ability_name = "Shuriken"
	ninja.ability_cooldown = 4.0
	ninja.ability_description = "Lanza shuriken a todos los enemigos"
	characters.append(ninja)

	var mage = CharacterData.new()
	mage.id = "mage"
	mage.display_name = "Mago"
	mage.color = Color(0.6, 0.2, 0.8)
	mage.max_health = 70.0
	mage.attack_damage = 30.0
	mage.attack_speed = 0.6
	mage.crit_chance = 0.15
	mage.hit_chance = 0.9
	mage.ability_name = "Bola de Fuego"
	mage.ability_cooldown = 7.0
	mage.ability_description = "Daño masivo en área"
	characters.append(mage)

	var berserker = CharacterData.new()
	berserker.id = "berserker"
	berserker.display_name = "Berserker"
	berserker.color = Color(0.8, 0.1, 0.1)
	berserker.max_health = 120.0
	berserker.attack_damage = 20.0
	berserker.attack_speed = 1.2
	berserker.crit_chance = 0.2
	berserker.hit_chance = 0.8
	berserker.ability_name = "Frenesí"
	berserker.ability_cooldown = 8.0
	berserker.ability_description = "Ataque x3 pero pierde 30% HP"
	characters.append(berserker)

	var healer = CharacterData.new()
	healer.id = "healer"
	healer.display_name = "Sanador"
	healer.color = Color(0.2, 0.8, 0.2)
	healer.max_health = 90.0
	healer.attack_damage = 8.0
	healer.attack_speed = 0.7
	healer.crit_chance = 0.05
	healer.hit_chance = 0.95
	healer.ability_name = "Curación"
	healer.ability_cooldown = 5.0
	healer.ability_description = "Se cura 40% de su vida max"
	characters.append(healer)

	var assassin = CharacterData.new()
	assassin.id = "assassin"
	assassin.display_name = "Asesino"
	assassin.color = Color(0.5, 0.0, 0.5)
	assassin.max_health = 75.0
	assassin.attack_damage = 35.0
	assassin.attack_speed = 1.3
	assassin.crit_chance = 0.4
	assassin.hit_chance = 0.75
	assassin.ability_name = "Veneno"
	assassin.ability_cooldown = 6.0
	assassin.ability_description = "Envenena al objetivo, daño por segundo"
	characters.append(assassin)

	var tank = CharacterData.new()
	tank.id = "tank"
	tank.display_name = "Tanque"
	tank.color = Color(0.5, 0.5, 0.5)
	tank.max_health = 250.0
	tank.attack_damage = 8.0
	tank.attack_speed = 0.5
	tank.crit_chance = 0.05
	tank.hit_chance = 0.9
	tank.ability_name = "Fortaleza"
	tank.ability_cooldown = 10.0
	tank.ability_description = "Se vuelve invulnerable 3 segundos"
	characters.append(tank)

	var archer = CharacterData.new()
	archer.id = "archer"
	archer.display_name = "Arquero"
	archer.color = Color(0.4, 0.6, 0.2)
	archer.max_health = 85.0
	archer.attack_damage = 18.0
	archer.attack_speed = 1.1
	archer.crit_chance = 0.25
	archer.hit_chance = 0.9
	archer.ability_name = "Lluvia de Flechas"
	archer.ability_cooldown = 7.0
	archer.ability_description = "Daño en área a todos los enemigos"
	characters.append(archer)

	var jester = CharacterData.new()
	jester.id = "jester"
	jester.display_name = "Bufón"
	jester.color = Color(0.9, 0.5, 0.1)
	jester.max_health = 95.0
	jester.attack_damage = 12.0
	jester.attack_speed = 1.0
	jester.crit_chance = 0.15
	jester.hit_chance = 0.85
	jester.ability_name = "Caos"
	jester.ability_cooldown = 5.0
	jester.ability_description = "Roba 20% del ataque al rival"
	characters.append(jester)

	var sleeper = CharacterData.new()
	sleeper.id = "sleeper"
	sleeper.display_name = "Dormilón"
	sleeper.color = Color(0.3, 0.3, 0.7)
	sleeper.max_health = 100.0
	sleeper.attack_damage = 10.0
	sleeper.attack_speed = 0.6
	sleeper.crit_chance = 0.1
	sleeper.hit_chance = 0.9
	sleeper.ability_name = "Sueño Profundo"
	sleeper.ability_cooldown = 8.0
	sleeper.ability_description = "Se duerme: cada ataque lo cura 15%"
	characters.append(sleeper)

	return characters

static func get_character_by_id(char_id: String) -> CharacterData:
	for c in get_all_characters():
		if c.id == char_id:
			return c
	return null
