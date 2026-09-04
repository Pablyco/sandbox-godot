class_name Fighter
extends CharacterBody2D

signal died(fighter: Fighter)
signal health_changed(fighter: Fighter, current: float, max_val: float)
signal ability_used(fighter: Fighter, ability_name: String)
signal attack_landed(fighter: Fighter, target: Fighter, damage: float, is_crit: bool)

var data: CharacterData
var current_health: float
var max_health: float
var ability_timer: float = 0.0
var attack_timer: float = 0.0
var is_alive: bool = true
var is_sleeping: bool = false
var is_invulnerable: bool = false
var invulnerable_timer: float = 0.0
var poison_timer: float = 0.0
var poison_damage: float = 0.0
var blocked_next_attack: bool = false
var stolen_attack: float = 0.0

@onready var sprite: ColorRect = $Sprite
@onready var health_bar: ProgressBar = $HealthBar
@onready var name_label: Label = $NameLabel
@onready var ability_cooldown_bar: ProgressBar = $AbilityCooldownBar
@onready var damage_numbers: Node2D = $DamageNumbers

func setup(char_data: CharacterData) -> void:
	data = char_data
	max_health = data.max_health
	current_health = max_health
	attack_timer = 1.0 / data.attack_speed
	ability_timer = data.ability_cooldown
	_update_ui()

func _ready() -> void:
	$HitArea.body_entered.connect(_on_hit_area_body_entered)

func _process(delta: float) -> void:
	if not is_alive:
		return

	if is_invulnerable:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			is_invulnerable = false
			_sprite_modulate_white()

	if poison_timer > 0:
		poison_timer -= delta
		_take_damage_no_evade(poison_damage * delta)
		if poison_timer <= 0:
			poison_damage = 0.0

	if is_sleeping:
		return

	ability_timer -= delta
	attack_timer -= delta

	if ability_timer <= 0:
		_use_ability()
		ability_timer = data.ability_cooldown

	if attack_timer <= 0:
		_try_attack()
		attack_timer = 1.0 / data.attack_speed

	_update_ui()

func _try_attack() -> void:
	var target = _find_nearest_enemy()
	if target == null:
		return

	if not _roll_hit():
		_show_miss_number()
		return

	var dmg = data.attack_damage + stolen_attack
	var is_crit = _roll_crit()
	if is_crit:
		dmg *= 3.0
		stolen_attack = 0.0

	target._take_damage(dmg)
	attack_landed.emit(self, target, dmg, is_crit)

func _use_ability() -> void:
	match data.id:
		"knight":
			blocked_next_attack = true
			_show_ability_text("BLOQUEO!")
		"ninja":
			for e in _get_all_enemies():
				e._take_damage(data.attack_damage * 0.5)
			_show_ability_text("SHURIKEN!")
		"mage":
			for e in _get_all_enemies():
				e._take_damage(data.attack_damage * 1.5)
			_show_ability_text("FUEGO!")
		"berserker":
			_take_damage_no_evade(max_health * 0.3)
			for e in _get_all_enemies():
				e._take_damage(data.attack_damage * 2.0)
			_show_ability_text("FRENEESI!")
		"healer":
			current_health = minf(current_health + max_health * 0.4, max_health)
			_show_ability_text("¡CURA!")
		"assassin":
			var target = _find_nearest_enemy()
			if target:
				target.poison_timer = 3.0
				target.poison_damage = data.attack_damage * 0.3
				_show_ability_text("¡VENENO!")
		"tank":
			is_invulnerable = true
			invulnerable_timer = 3.0
			_show_ability_text("¡FORTALEZA!")
		"archer":
			for e in _get_all_enemies():
				e._take_damage(data.attack_damage * 0.8)
			_show_ability_text("¡FLECHAS!")
		"jester":
			var target = _find_nearest_enemy()
			if target:
				stolen_attack += target.data.attack_damage * 0.2
				target.data.attack_damage *= 0.8
				_show_ability_text("¡CAOS!")
		"sleeper":
			is_sleeping = true
			_show_ability_text("Zzz...")
			await get_tree().create_timer(2.0).timeout
			if is_alive:
				is_sleeping = false

	ability_used.emit(self, data.ability_name)
	ability_timer = data.ability_cooldown
	_juice_pulse()

func _take_damage(amount: float) -> void:
	if not is_alive:
		return
	if is_invulnerable:
		_show_absorbed_number()
		return
	if data.id == "knight" and blocked_next_attack:
		blocked_next_attack = false
		_show_absorbed_number()
		return
	if data.id == "sleeper" and is_sleeping:
		current_health = minf(current_health + amount * 0.15, max_health)
		_show_heal_number(amount * 0.15)
		_take_damage_no_evade(amount * 0.85)
		return
	_take_damage_no_evade(amount)

func _take_damage_no_evade(amount: float) -> void:
	if not is_alive:
		return
	current_health -= amount
	_spawn_damage_number(amount, false)
	_juice_hit()
	health_changed.emit(self, current_health, max_health)
	if current_health <= 0:
		current_health = 0
		is_alive = false
		died.emit(self)
		_juice_death()

func _find_nearest_enemy() -> Fighter:
	var enemies = _get_all_enemies()
	var nearest: Fighter = null
	var min_dist = INF
	for e in enemies:
		if e.is_alive:
			var d = global_position.distance_to(e.global_position)
			if d < min_dist:
				min_dist = d
				nearest = e
	return nearest

func _get_all_enemies() -> Array:
	var scene = get_tree().current_scene
	var fighters_node = scene.get_node_or_null("Fighters")
	if fighters_node == null:
		fighters_node = scene.get_node_or_null("Battlefield/Fighters")
	if fighters_node == null:
		return []
	var result: Array = []
	for child in fighters_node.get_children():
		if child != self and child is Fighter and child.is_alive:
			result.append(child)
	return result

func _roll_crit() -> bool:
	return randf() < data.crit_chance

func _roll_hit() -> bool:
	return randf() < data.hit_chance

func _spawn_damage_number(amount: float, is_crit: bool) -> void:
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	dn.position = global_position + Vector2(randf_range(-20, 20), -30)
	dn.setup(amount, is_crit)
	ui_layer.add_child(dn)

func _show_miss_number() -> void:
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	dn.position = global_position + Vector2(randf_range(-20, 20), -30)
	dn.setup_miss()
	ui_layer.add_child(dn)

func _show_heal_number(amount: float) -> void:
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	dn.position = global_position + Vector2(randf_range(-20, 20), -30)
	dn.setup_heal(amount)
	ui_layer.add_child(dn)

func _show_absorbed_number() -> void:
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	dn.position = global_position + Vector2(randf_range(-20, 20), -30)
	dn.setup_absorbed()
	ui_layer.add_child(dn)

func _show_ability_text(text: String) -> void:
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	dn.position = global_position + Vector2(randf_range(-20, 20), -50)
	dn.setup_ability(text)
	ui_layer.add_child(dn)

func _update_ui() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	if ability_cooldown_bar:
		ability_cooldown_bar.max_value = data.ability_cooldown
		ability_cooldown_bar.value = maxf(ability_cooldown_bar.value, ability_timer)
	if name_label:
		name_label.text = data.display_name
	if sprite:
		sprite.color = data.color if is_alive else data.color.darkened(0.5)

func _juice_hit() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.05)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)

func _juice_pulse() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.1)
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)

func _juice_death() -> void:
	if sprite:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.tween_property(sprite, "rotation", deg_to_rad(90), 0.5)
		tween.chain().tween_callback(queue_free)

func _sprite_modulate_white() -> void:
	if sprite:
		sprite.modulate = Color.WHITE
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color.WHITE
