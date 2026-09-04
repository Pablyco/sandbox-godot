extends Control

@onready var versus_btn: Button = $VBoxContainer/VersusButton
@onready var battlefield_btn: Button = $VBoxContainer/BattlefieldButton
@onready var title_label: Label = $TitleLabel

func _ready() -> void:
	versus_btn.pressed.connect(_on_versus_pressed)
	battlefield_btn.pressed.connect(_on_battlefield_pressed)
	_animate_title()

func _on_versus_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/versus/versus_select.tscn")

func _on_battlefield_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/battlefield/battlefield_select.tscn")

func _animate_title() -> void:
	if title_label:
		var tween = create_tween().set_loops()
		tween.tween_property(title_label, "scale", Vector2(1.05, 1.05), 0.5)
		tween.tween_property(title_label, "scale", Vector2.ONE, 0.5)
