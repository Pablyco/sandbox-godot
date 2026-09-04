extends Control

var characters: Array[CharacterData] = []
var selected: Array[CharacterData] = []
var character_buttons: Array[Button] = []

@onready var grid: GridContainer = $PanelContainer/VBoxContainer/GridContainer
@onready var fight_btn: Button = $PanelContainer/VBoxContainer/HBoxContainer/FightButton
@onready var back_btn: Button = $PanelContainer/VBoxContainer/HBoxContainer/BackButton
@onready var selection_label: Label = $PanelContainer/VBoxContainer/SelectionLabel
@onready var preview_p1: PanelContainer = $PanelContainer/VBoxContainer/Previews/PreviewP1
@onready var preview_p2: PanelContainer = $PanelContainer/VBoxContainer/Previews/PreviewP2

func _ready() -> void:
	characters = CharacterDatabase.get_all_characters()
	fight_btn.pressed.connect(_on_fight_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	fight_btn.disabled = true
	_create_character_buttons()

func _create_character_buttons() -> void:
	for c in characters:
		var btn = Button.new()
		btn.text = c.display_name
		btn.custom_minimum_size = Vector2(160, 50)
		btn.toggle_mode = true
		btn.pressed.connect(_on_character_pressed.bind(c, btn))
		grid.add_child(btn)
		character_buttons.append(btn)
	_update_previews()

func _on_character_pressed(char_data: CharacterData, btn: Button) -> void:
	if selected.has(char_data):
		selected.erase(char_data)
		btn.button_pressed = false
		btn.modulate = Color.WHITE
	elif selected.size() < 2:
		selected.append(char_data)
		btn.button_pressed = true
		btn.modulate = char_data.color
	else:
		var old = selected[0]
		selected.erase(old)
		for b in character_buttons:
			if b.text == old.display_name:
				b.button_pressed = false
				b.modulate = Color.WHITE
		selected.append(char_data)
		btn.button_pressed = true
		btn.modulate = char_data.color

	fight_btn.disabled = selected.size() != 2
	_update_previews()
	_update_selection_label()

func _update_previews() -> void:
	if selected.size() >= 1:
		_set_preview(preview_p1, selected[0])
	else:
		_clear_preview(preview_p1)
	if selected.size() >= 2:
		_set_preview(preview_p2, selected[1])
	else:
		_clear_preview(preview_p2)

func _set_preview(panel: PanelContainer, char_data: CharacterData) -> void:
	var label = panel.get_node_or_null("VBoxContainer/NameLabel")
	var stats = panel.get_node_or_null("VBoxContainer/StatsLabel")
	if label:
		label.text = char_data.display_name
		label.add_theme_color_override("font_color", char_data.color)
	if stats:
		stats.text = "HP: %d | ATK: %d | SPD: %.1f" % [int(char_data.max_health), int(char_data.attack_damage), char_data.attack_speed]

func _clear_preview(panel: PanelContainer) -> void:
	var label = panel.get_node_or_null("VBoxContainer/NameLabel")
	var stats = panel.get_node_or_null("VBoxContainer/StatsLabel")
	if label:
		label.text = "---"
		label.add_theme_color_override("font_color", Color.WHITE)
	if stats:
		stats.text = ""

func _update_selection_label() -> void:
	if selection_label:
		selection_label.text = "Seleccioná 2 personajes (%d/2)" % selected.size()

func _on_fight_pressed() -> void:
	if selected.size() != 2:
		return
	var game_state = get_node_or_null("/root/GameState")
	if game_state:
		game_state.versus_p1 = selected[0]
		game_state.versus_p2 = selected[1]
	get_tree().change_scene_to_file("res://scenes/versus/versus_battle.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
