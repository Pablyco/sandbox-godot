extends Node2D

var fighter_scene = preload("res://scenes/characters/fighter.tscn")
var fighters: Array[Fighter] = []
var alive_count: int = 0
var placement_order: Array[CharacterData] = []
var battle_over: bool = false

@onready var camera: Camera2D = $Camera2D
@onready var fighters_node: Node2D = $Fighters
@onready var ui_layer: CanvasLayer = $UILayer
@onready var ranking_panel: Control = $UILayer/RankingPanel
@onready var ranking_label: Label = $UILayer/RankingPanel/VBoxContainer/RankingLabel
@onready var victory_screen: Control = $UILayer/VictoryScreen

const ARENA_SIZE = Vector2(1800, 1000)
const ARENA_OFFSET = Vector2(60, 90)

func _ready() -> void:
	victory_screen.visible = false
	ranking_panel.visible = true
	_spawn_fighters()
	_setup_camera()
	_update_ranking()

func _spawn_fighters() -> void:
	var gs = get_node_or_null("/root/GameState")
	if gs == null:
		return

	var chars = gs.battlefield_characters
	var positions: Array[Vector2] = []

	for c in chars:
		var pos = _get_random_position(positions)
		positions.append(pos)

		var f = fighter_scene.instantiate()
		f.global_position = pos
		fighters_node.add_child(f)
		f.setup(c)
		f.died.connect(_on_fighter_died.bind(f))
		fighters.append(f)

	alive_count = fighters.size()

func _get_random_position(used: Array[Vector2]) -> Vector2:
	for i in range(100):
		var pos = Vector2(
			randf_range(ARENA_OFFSET.x, ARENA_OFFSET.x + ARENA_SIZE.x),
			randf_range(ARENA_OFFSET.y, ARENA_OFFSET.y + ARENA_SIZE.y)
		)
		var valid = true
		for u in used:
			if pos.distance_to(u) < 80:
				valid = false
				break
		if valid:
			return pos
	return ARENA_OFFSET + Vector2(randf() * ARENA_SIZE.x, randf() * ARENA_SIZE.y)

func _setup_camera() -> void:
	if camera:
		camera.position = Vector2(960, 540)
		camera.make_current()

func _on_fighter_died(dead_fighter: Fighter) -> void:
	alive_count -= 1
	placement_order.append(dead_fighter.data)
	_update_ranking()

	if alive_count <= 1:
		_end_battle()

func _end_battle() -> void:
	battle_over = true

	var winner_data: CharacterData = null
	for f in fighters:
		if f.is_alive:
			winner_data = f.data
			break

	if winner_data:
		placement_order.append(winner_data)

	Engine.time_scale = 0.15
	await get_tree().create_timer(0.8, true, false, true).timeout
	Engine.time_scale = 1.0

	_show_victory_screen(winner_data)

func _show_victory_screen(winner_data: CharacterData) -> void:
	if victory_screen == null or winner_data == null:
		return

	victory_screen.visible = true
	ranking_panel.visible = false

	var name_label = victory_screen.get_node_or_null("VBoxContainer/NameLabel")
	var sprite_rect = victory_screen.get_node_or_null("VBoxContainer/SpriteRect")
	var subtitle = victory_screen.get_node_or_null("VBoxContainer/SubtitleLabel")
	var ranking_text = victory_screen.get_node_or_null("VBoxContainer/RankingText")

	if name_label:
		name_label.text = winner_data.display_name
		name_label.add_theme_color_override("font_color", winner_data.color)
	if sprite_rect:
		sprite_rect.color = winner_data.color
	if subtitle:
		subtitle.text = "CHAMPION!"
	if ranking_text:
		var rt = ""
		for i in range(placement_order.size()):
			var place = placement_order.size() - i
			rt += "#%d %s\n" % [place, placement_order[i].display_name]
		ranking_text.text = rt

	_animate_victory()

func _animate_victory() -> void:
	var name_label = victory_screen.get_node_or_null("VBoxContainer/NameLabel")
	var sprite_rect = victory_screen.get_node_or_null("VBoxContainer/SpriteRect")

	if name_label:
		name_label.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(name_label, "scale", Vector2(1.2, 1.2), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(name_label, "scale", Vector2.ONE, 0.2)

	if sprite_rect:
		sprite_rect.scale = Vector2.ZERO
		var tween2 = create_tween()
		tween2.tween_property(sprite_rect, "scale", Vector2(1.5, 1.5), 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween2.tween_property(sprite_rect, "scale", Vector2.ONE, 0.2)

func _update_ranking() -> void:
	if ranking_label == null:
		return
	var text = "=== TOP 10 ===\n"
	var alive_fighters: Array[Fighter] = []
	for f in fighters:
		if f.is_alive:
			alive_fighters.append(f)

	for i in range(alive_fighters.size()):
		var f = alive_fighters[i]
		var pct = int(f.current_health / f.max_health * 100)
		text += "#%d %s [HP %d%%]\n" % [i + 1, f.data.display_name, pct]

	for i in range(placement_order.size()):
		var place = alive_fighters.size() + i + 1
		text += "#%d %s [ELIMINATED]\n" % [place, placement_order[i].display_name]

	ranking_label.text = text

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
