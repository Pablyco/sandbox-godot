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

# Movimiento
const MELEE_RANGE: float = 70.0
const KNOCKBACK_FORCE: float = 180.0
const KNOCKBACK_DAMPING: float = 420.0
const KNOCKBACK_MAX_SPEED: float = 240.0
const SPRITE_DISPLAY_SIZE: float = 90.0
var base_scale: Vector2 = Vector2.ONE
var move_speed: float = 120.0
var velocity_vec: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO
var facing: int = 1  # 1 = derecha, -1 = izquierda

# Estados especiales
var rage_mode: bool = false
var rage_timer: float = 0.0
var rage_damage_mult: float = 1.0
var is_charmed: bool = false
var charmed_by: Fighter = null
var charm_timer: float = 0.0
var is_counter_stance: bool = false
var counter_timer: float = 0.0
var is_demon_mode: bool = false
var demon_timer: float = 0.0
var is_slowed: bool = false
var slow_timer: float = 0.0
var slow_amount: float = 1.0
var accuracy_debuff: float = 0.0
var accuracy_debuff_timer: float = 0.0
var is_stunned: bool = false
var stun_timer: float = 0.0
var blocked_next_attack: bool = false
var ability_anim_pending: bool = false

@onready var sprite: Sprite2D = $SpriteContainer/Sprite
@onready var sprite_container: Node2D = $SpriteContainer
@onready var health_bar: ProgressBar = $HealthBar
@onready var name_label: Label = $NameLabel
@onready var ability_cooldown_bar: ProgressBar = $AbilityCooldownBar

func setup(char_data: CharacterData) -> void:
	data = char_data
	max_health = data.max_health
	current_health = max_health
	attack_timer = 1.0 / data.attack_speed
	ability_timer = data.ability_cooldown * randf_range(0.3, 1.0)
	move_speed = data.move_speed
	_load_sprite_textures()
	_update_ui()

func _load_sprite_textures() -> void:
	if not sprite:
		return
	if data.sprite_path != "":
		var tex = load(data.sprite_path)
		if tex is Texture2D:
			sprite.texture = tex
			sprite.centered = true
			var tex_size = tex.get_size()
			if tex_size.x > 0:
				var scale = SPRITE_DISPLAY_SIZE / maxf(tex_size.x, tex_size.y)
				base_scale = Vector2.ONE * scale
				sprite.scale = base_scale

func _get_world_viewport_rect() -> Rect2:
	var cam = get_viewport().get_camera_2d()
	if cam == null:
		return Rect2()
	var view_size = get_viewport().get_visible_rect().size / cam.zoom
	return Rect2(cam.global_position - view_size / 2.0, view_size)

func _apply_boundary() -> void:
	var rect = _get_world_viewport_rect()
	if rect.size.x <= 0 or rect.size.y <= 0:
		return
	if global_position.x < rect.position.x:
		global_position.x = rect.position.x
		knockback_velocity.x = absf(knockback_velocity.x)
	elif global_position.x > rect.end.x:
		global_position.x = rect.end.x
		knockback_velocity.x = -absf(knockback_velocity.x)
	if global_position.y < rect.position.y:
		global_position.y = rect.position.y
		knockback_velocity.y = absf(knockback_velocity.y)
	elif global_position.y > rect.end.y:
		global_position.y = rect.end.y
		knockback_velocity.y = -absf(knockback_velocity.y)

func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	_update_timers(delta)

	# Movimiento: acercarse al enemigo más cercano hasta estar en rango melee
	var target = _get_attack_target()
	if target != null and not is_stunned and not is_charmed:
		var to_target = target.global_position - global_position
		var dist = to_target.length()

		if dist > MELEE_RANGE:
			var dir = to_target.normalized()
			var speed = move_speed
			if is_slowed:
				speed *= slow_amount
			velocity_vec = dir * speed
		else:
			velocity_vec = Vector2.ZERO
		facing = 1 if to_target.x >= 0 else -1
	elif not is_stunned:
		velocity_vec = Vector2.ZERO

	# Aplicar knockback (decae con el tiempo, con cap de velocidad)
	if knockback_velocity.length() > 5:
		knockback_velocity = knockback_velocity.limit_length(KNOCKBACK_MAX_SPEED)
		velocity_vec += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DAMPING * delta)
	else:
		knockback_velocity = Vector2.ZERO

	if is_stunned:
		velocity_vec = knockback_velocity

	velocity = velocity_vec
	move_and_slide()

	_apply_boundary()
	_update_sprite_scale()
	_update_ui()

func _process(delta: float) -> void:
	if not is_alive:
		return

	if is_stunned or is_charmed:
		return

	ability_timer -= delta
	attack_timer -= delta

	if ability_timer <= 0:
		_use_ability()
		ability_timer = data.ability_cooldown

	if attack_timer <= 0:
		if _is_in_melee_range():
			_try_attack()
			var effective_speed = data.attack_speed
			if is_slowed:
				effective_speed *= slow_amount
			attack_timer = 1.0 / effective_speed

func _get_attack_target() -> Fighter:
	if is_charmed and charmed_by and charmed_by.is_alive:
		return charmed_by
	return _find_nearest_enemy()

func _is_in_melee_range() -> bool:
	var target = _get_attack_target()
	if target == null:
		return false
	return global_position.distance_to(target.global_position) <= MELEE_RANGE + 20

func _update_timers(delta: float) -> void:
	# Rage mode (Pompompurin)
	if rage_mode:
		rage_timer -= delta
		if rage_timer <= 0:
			rage_mode = false
			rage_damage_mult = 1.0

	# Charm (My Melody)
	if is_charmed:
		charm_timer -= delta
		if charm_timer <= 0:
			is_charmed = false
			charmed_by = null

	# Counter stance (Kuromi)
	if is_counter_stance:
		counter_timer -= delta
		if counter_timer <= 0:
			is_counter_stance = false

	# Demon mode (Hello Kitty)
	if is_demon_mode:
		demon_timer -= delta
		if demon_timer <= 0:
			is_demon_mode = false

	# Slow (Gudetama)
	if is_slowed:
		slow_timer -= delta
		if slow_timer <= 0:
			is_slowed = false
			slow_amount = 1.0

	# Accuracy debuff (Hangyodon)
	if accuracy_debuff_timer > 0:
		accuracy_debuff_timer -= delta
		if accuracy_debuff_timer <= 0:
			accuracy_debuff = 0.0

	# Stun
	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0:
			is_stunned = false

func _try_attack() -> void:
	var target = _get_attack_target()
	if target == null:
		return

	var effective_hit = data.hit_chance - accuracy_debuff
	if not _roll_hit_with(effective_hit):
		_show_miss_number()
		_juice_windup()
		return

	var dmg = data.attack_damage * rage_damage_mult
	var is_crit = _roll_crit()
	if is_crit:
		dmg *= 3.0

	# Cinnamoroll: damage bonus for speed
	if data.id == "cinnamoroll":
		dmg *= 1.2

	# Aplicar knockback al enemigo (con fuerza extra si es critico)
	var knockback_dir = (target.global_position - global_position).normalized()
	var kb_force = KNOCKBACK_FORCE
	if is_crit:
		kb_force *= 1.5
	target._apply_knockback(knockback_dir, kb_force)

	target._take_damage(dmg)
	_juice_attack_animation(target)
	attack_landed.emit(self, target, dmg, is_crit)

func _use_ability() -> void:
	match data.id:
		"pompompurin":
			_ability_pompompurin()
		"pochacco":
			_ability_pochacco()
		"badtz":
			_ability_badtz()
		"hangyodon":
			_ability_hangyodon()
		"melody":
			_ability_melody()
		"gudetama":
			_ability_gudetama()
		"cinnamoroll":
			_ability_cinnamoroll()
		"tuxedosam":
			_ability_tuxedosam()
		"kuromi":
			_ability_kuromi()
		"kitty":
			_ability_kitty()

	ability_used.emit(self, data.ability_name)
	ability_timer = data.ability_cooldown
	_juice_pulse()

# --- HABILIDADES ---

func _ability_pompompurin() -> void:
	current_health = minf(current_health + max_health * 0.15, max_health)
	rage_mode = true
	rage_timer = 5.0
	rage_damage_mult = 1.8
	_show_ability_text("ATE MY PUDDING!")
	_show_heal_number(max_health * 0.15)
	_play_ability_animation()
	_juice_enrage()

func _ability_pochacco() -> void:
	var target = _find_nearest_enemy()
	if target:
		var dmg = data.attack_damage * 2.0
		target._take_damage(dmg)
		target._apply_stun(1.0)
		var kb_dir = (target.global_position - global_position).normalized()
		target._apply_knockback(kb_dir, KNOCKBACK_FORCE * 2.0)
		_show_ability_text("OLÉ!")
		_play_ability_animation()
		_attack_towards(target.global_position)

func _ability_badtz() -> void:
	var dmg = data.attack_damage * 1.5
	for e in _get_all_enemies():
		var dist = global_position.distance_to(e.global_position)
		if dist < 200:
			e._take_damage(dmg)
			var kb_dir = (e.global_position - global_position).normalized()
			e._apply_knockback(kb_dir, KNOCKBACK_FORCE)
	_show_ability_text("SPIN KICK!")
	_play_ability_animation()
	_juice_spin()

func _ability_hangyodon() -> void:
	for e in _get_all_enemies():
		e._take_damage(data.attack_damage * 0.8)
		e.accuracy_debuff = 0.4
		e.accuracy_debuff_timer = 4.0
	_show_ability_text("BITTER DRINK!")
	_play_ability_animation()
	_juice_vomit()

func _ability_melody() -> void:
	var target = _find_nearest_enemy()
	if target:
		target.is_charmed = true
		target.charmed_by = self
		target.charm_timer = 3.0
		_show_ability_text("CHARM~")
		_play_ability_animation()
		_show_charm_effect(target)

func _ability_gudetama() -> void:
	for e in _get_all_enemies():
		var dist = global_position.distance_to(e.global_position)
		if dist < 250:
			e.is_slowed = true
			e.slow_timer = 4.0
			e.slow_amount = 0.6
	_show_ability_text("NAPS TIME...")
	_play_ability_animation()
	_juice_sleep()

func _ability_cinnamoroll() -> void:
	var target = _find_nearest_enemy()
	if target:
		var dmg = data.attack_damage * 3.0
		target._take_damage(dmg)
		_take_damage_no_evade(max_health * 0.2)
		var kb_dir = (target.global_position - global_position).normalized()
		target._apply_knockback(kb_dir, KNOCKBACK_FORCE * 2.5)
		_show_ability_text("KAMIKAZE!")
		_play_ability_animation()
		_attack_towards(target.global_position)
		_juice_dash()

func _ability_tuxedosam() -> void:
	var dmg = data.attack_damage * 2.5
	for e in _get_all_enemies():
		var dist = global_position.distance_to(e.global_position)
		if dist < 250:
			e._take_damage(dmg)
			var kb_dir = Vector2.UP + (e.global_position - global_position).normalized() * 0.3
			e._apply_knockback(kb_dir.normalized(), KNOCKBACK_FORCE * 1.8)
	_show_ability_text("PLANCHAAA!")
	_play_ability_animation()
	_juice_slam()

func _ability_kuromi() -> void:
	is_counter_stance = true
	counter_timer = 3.0
	_show_ability_text("HIT ME!?")
	_play_ability_animation()
	_juice_taunt()

func _ability_kitty() -> void:
	is_demon_mode = true
	demon_timer = 3.0
	_show_ability_text("DEMON MODE")
	_play_ability_animation()
	_juice_demon()
	for e in _get_all_enemies():
		for i in range(5):
			var dmg = data.attack_damage * 0.6
			await get_tree().create_timer(0.15).timeout
			if is_alive and e.is_alive:
				e._take_damage(dmg)
				var kb_dir = (e.global_position - global_position).normalized()
				e._apply_knockback(kb_dir, KNOCKBACK_FORCE * 0.6)

# --- SISTEMA DE DAÑO ---

func _take_damage(amount: float) -> void:
	if not is_alive:
		return

	# Kuromi counter stance: refleja doble
	if is_counter_stance and data.id == "kuromi":
		var attacker = _find_nearest_enemy()
		if attacker:
			attacker._take_damage(amount * 2.0)
			_show_ability_text("REFLECT!")
			_show_counter_number(amount * 2.0)
		_show_absorbed_number()
		is_counter_stance = false
		return

	if blocked_next_attack:
		blocked_next_attack = false
		_show_absorbed_number()
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

func _apply_knockback(direction: Vector2, force: float) -> void:
	if not is_alive:
		return
	knockback_velocity += direction * force
	_juice_knockback()

func _apply_stun(duration: float) -> void:
	is_stunned = true
	stun_timer = maxf(stun_timer, duration)

func _apply_slow(duration: float, amount: float) -> void:
	is_slowed = true
	slow_timer = maxf(slow_timer, duration)
	slow_amount = mini(slow_amount, amount)

# --- UTILIDADES ---

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

func _roll_hit_with(effective_chance: float) -> bool:
	return randf() < effective_chance

func _roll_hit() -> bool:
	return _roll_hit_with(data.hit_chance)

# --- DAMAGE NUMBERS ---

func _spawn_damage_number(amount: float, is_crit: bool) -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -30)
		dn.setup(amount, is_crit)

func _show_miss_number() -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -30)
		dn.setup_miss()

func _show_heal_number(amount: float) -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -30)
		dn.setup_heal(amount)

func _show_absorbed_number() -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -30)
		dn.setup_absorbed()

func _show_ability_text(text: String) -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -50)
		dn.setup_ability(text)

func _show_counter_number(amount: float) -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = global_position + Vector2(randf_range(-20, 20), -40)
		dn.setup_counter(amount)

func _show_charm_effect(target: Fighter) -> void:
	var dn = _get_damage_number_scene()
	if dn:
		dn.position = target.global_position + Vector2(0, -40)
		dn.setup_ability("IN LOVE~")

func _get_damage_number_scene():
	var scene = get_tree().current_scene
	var ui_layer = scene.get_node_or_null("UILayer/DamageNumbers")
	if ui_layer == null:
		return null
	var dn = preload("res://scenes/ui/damage_number.tscn").instantiate()
	ui_layer.add_child(dn)
	return dn

# --- UI ---

func _update_sprite_scale() -> void:
	# El flip se aplica al contenedor; los tweens de squash van al Sprite hijo
	if sprite_container and not ability_anim_pending:
		var target_scale = Vector2.ONE
		var motion = velocity_vec.length() / maxf(move_speed, 1.0)
		if motion > 0.2:
			target_scale = Vector2(1.0 + motion * 0.15, 1.0 - motion * 0.15)
		sprite_container.scale = Vector2(target_scale.x * facing, target_scale.y)

func _update_ui() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
	if ability_cooldown_bar:
		ability_cooldown_bar.max_value = data.ability_cooldown
		ability_cooldown_bar.value = maxf(0, ability_timer)
	if name_label:
		name_label.text = data.display_name
	if sprite:
		if not is_alive:
			sprite.modulate = data.color.darkened(0.5)
		elif rage_mode:
			sprite.modulate = data.color.lightened(0.3)
		elif is_demon_mode:
			sprite.modulate = Color(1, 0.2, 0.2)
		elif is_counter_stance:
			sprite.modulate = Color(0.8, 0.2, 1.0)
		elif is_charmed:
			sprite.modulate = Color(1, 0.5, 0.8)
		elif is_stunned:
			sprite.modulate = data.color.darkened(0.3)
		elif is_slowed:
			sprite.modulate = Color(0.5, 0.6, 1.0)
		else:
			sprite.modulate = Color.WHITE

# --- JUICE ---

func _juice_hit() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", base_scale * Vector2(1.2, 0.8), 0.05)
		tween.tween_property(sprite, "scale", base_scale, 0.1)

func _juice_knockback() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "rotation", facing * deg_to_rad(10), 0.05)
		tween.tween_property(sprite, "rotation", 0.0, 0.1)

func _juice_pulse() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", base_scale * 1.3, 0.1)
		tween.tween_property(sprite, "scale", base_scale, 0.15)

func _juice_death() -> void:
	if sprite:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.tween_property(sprite, "rotation", deg_to_rad(90), 0.5)
		tween.chain().tween_callback(queue_free)

func _juice_enrage() -> void:
	if self:
		var tween = create_tween().set_loops(5)
		tween.tween_property(self, "self_modulate", Color(1, 0.5, 0), 0.1)
		tween.tween_property(self, "self_modulate", Color.WHITE, 0.1)

func _juice_spin() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "rotation", deg_to_rad(720), 0.5)
		tween.tween_property(sprite, "rotation", 0.0, 0.1)

func _juice_vomit() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", base_scale * Vector2(1.0, 0.7), 0.1)
		tween.tween_property(sprite, "scale", base_scale, 0.2)

func _juice_sleep() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "position:y", sprite.position.y + 5, 0.3)
		tween.tween_property(sprite, "position:y", sprite.position.y, 0.3)

func _juice_dash() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", base_scale * Vector2(0.5, 1.5), 0.05)
		tween.tween_property(sprite, "scale", base_scale, 0.15)

func _juice_slam() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "scale", base_scale * Vector2(1.5, 0.5), 0.1)
		tween.tween_property(sprite, "scale", base_scale, 0.2)

func _juice_taunt() -> void:
	if self:
		var tween = create_tween().set_loops(3)
		tween.tween_property(self, "self_modulate", Color(1, 0.8, 1.0), 0.05)
		tween.tween_property(self, "self_modulate", Color.WHITE, 0.05)

func _juice_demon() -> void:
	if self:
		var tween = create_tween().set_loops(3)
		tween.tween_property(self, "self_modulate", Color(1, 0.1, 0.1), 0.1)
		tween.tween_property(self, "self_modulate", Color(1, 0.4, 0.4), 0.1)

func _juice_attack_animation(target: Fighter) -> void:
	if sprite:
		var tween = create_tween()
		var target_dir = signf(target.global_position.x - global_position.x)
		tween.tween_property(sprite, "position:x", sprite.position.x + target_dir * 12, 0.06)
		tween.tween_property(sprite, "position:x", sprite.position.x, 0.1)

func _juice_windup() -> void:
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "rotation", deg_to_rad(-12), 0.08)
		tween.tween_property(sprite, "rotation", 0.0, 0.1)

func _attack_towards(target_pos: Vector2) -> void:
	if sprite:
		var direction = (target_pos - global_position).normalized()
		var tween = create_tween()
		tween.tween_property(sprite, "position", sprite.position + direction * 30, 0.08)
		tween.tween_property(sprite, "position", sprite.position, 0.08)

# --- ABILITY ANIMATIONS ---

func _play_ability_animation() -> void:
	if not sprite or data.ability_sprite_path == "":
		return
	var ability_tex = load(data.ability_sprite_path)
	if ability_tex is not Texture2D:
		return
	var base_tex = sprite.texture
	var base_modulate = sprite.modulate
	ability_anim_pending = true
	sprite.texture = ability_tex
	var tex_size = ability_tex.get_size()
	if tex_size.x > 0:
		var s = SPRITE_DISPLAY_SIZE / maxf(tex_size.x, tex_size.y)
		sprite.scale = Vector2.ONE * s
	sprite.modulate = Color.WHITE
	sprite_container.scale = Vector2(1.15 * facing, 1.15)
	await get_tree().create_timer(0.4).timeout
	if not is_alive:
		ability_anim_pending = false
		return
	_restore_base_sprite(base_tex, base_modulate)
	ability_anim_pending = false

func _restore_base_sprite(base_tex: Texture2D, base_modulate: Color) -> void:
	if not sprite:
		return
	sprite.texture = base_tex
	sprite.scale = base_scale
	sprite.modulate = base_modulate
