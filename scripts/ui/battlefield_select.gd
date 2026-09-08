extends Control

@onready var start_btn: Button = $VBoxContainer/StartButton
@onready var back_btn: Button = $VBoxContainer/BackButton
@onready var info_label: Label = $VBoxContainer/InfoLabel

func _ready() -> void:
	start_btn.pressed.connect(_on_start_pressed)
	back_btn.pressed.connect(_on_back_pressed)

func _on_start_pressed() -> void:
	var gs = get_node_or_null("/root/GameState")
	if gs:
		gs.battlefield_characters = CharacterDatabase.get_all_characters()
		gs.placement_order.clear()
	get_tree().change_scene_to_file("res://scenes/battlefield/battlefield_battle.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
