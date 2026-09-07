extends Node2D

var fighter_scene = preload("res://scenes/characters/fighter.tscn")
var fighter1: Fighter = null
var fighter2: Fighter = null
var battle_over: bool = false
var winner: Fighter = null

@onready var camera: Camera2D = $Camera2D
@onready var fighters_node: Node2D = $Fighters
@onready var ui_layer: CanvasLayer = $UILayer
@onready var victory_screen: Control = $UILayer/VictoryScreen
@onready var hud: Control = $UILayer/HUD

func _ready() -> void:
	victory_screen.visible = false
	_spawn_fighters()
	_setup_camera()
	if hud:
		_hide_hud_for_versus()

func _spawn_fighters() -> void:
	var gs = get_node_or_null("/root/GameState")
	if gs == null or gs.versus_p1 == null or gs.versus_p2 == null:
		return

	fighter1 = fighter_scene.instantiate()
	fighter1.global_position = Vector2(860, 540)
	fighters_node.add_child(fighter1)
	fighter1.setup(gs.versus_p1)
	fighter1.died.connect(_on_fighter_died)

	fighter2 = fighter_scene.instantiate()
	fighter2.global_position = Vector2(1060, 540)
	fighters_node.add_child(fighter2)
	fighter2.setup(gs.versus_p2)
	fighter2.died.connect(_on_fighter_died)

func _setup_camera() -> void:
	if camera:
		camera.position = Vector2(960, 540)
		camera.make_current()

func _on_fighter_died(dead_fighter: Fighter) -> void:
	if battle_over:
		return
	battle_over = true

	Engine.time_scale = 0.2
	await get_tree().create_timer(0.5, true, false, true).timeout
	Engine.time_scale = 1.0

	if dead_fighter == fighter1:
		winner = fighter2
	else:
		winner = fighter1

	_show_victory_screen()

func _show_victory_screen() -> void:
	if victory_screen == null:
		return
	victory_screen.visible = true

	var name_label = victory_screen.get_node_or_null("VBoxContainer/NameLabel")
	var sprite_rect = victory_screen.get_node_or_null("VBoxContainer/SpriteRect")
	var subtitle = victory_screen.get_node_or_null("VBoxContainer/SubtitleLabel")

	if name_label and winner and winner.data:
		name_label.text = winner.data.display_name
		name_label.add_theme_color_override("font_color", winner.data.color)
	if sprite_rect and winner and winner.data:
		sprite_rect.color = winner.data.color
	if subtitle:
		subtitle.text = "WINS!"

	_animate_victory()

func _animate_victory() -> void:
	var name_label = victory_screen.get_node_or_null("VBoxContainer/NameLabel")
	var sprite_rect = victory_screen.get_node_or_null("VBoxContainer/SpriteRect")

	if name_label:
		name_label.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(name_label, "scale", Vector2(1.2, 1.2), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(name_label, "scale", Vector2.ONE, 0.2)

	if sprite_rect:
		sprite_rect.scale = Vector2.ZERO
		var tween2 = create_tween()
		tween2.tween_property(sprite_rect, "scale", Vector2(1.5, 1.5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween2.tween_property(sprite_rect, "scale", Vector2.ONE, 0.2)

func _hide_hud_for_versus() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
