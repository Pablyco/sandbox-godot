extends Node2D

@onready var label: Label = $Label

func setup(amount: float, is_crit: bool) -> void:
	if label:
		label.text = str(int(amount))
		if is_crit:
			label.add_theme_font_size_override("font_size", 32)
			label.modulate = Color.RED
			scale = Vector2(1.5, 1.5)
		else:
			label.add_theme_font_size_override("font_size", 22)
			label.modulate = Color.WHITE
	_animate()

func setup_miss() -> void:
	if label:
		label.text = "MISS"
		label.add_theme_font_size_override("font_size", 18)
		label.modulate = Color(0.7, 0.7, 0.7)
	_animate()

func setup_heal(amount: float) -> void:
	if label:
		label.text = "+" + str(int(amount))
		label.add_theme_font_size_override("font_size", 22)
		label.modulate = Color.GREEN
	_animate()

func setup_absorbed() -> void:
	if label:
		label.text = "BLOCK"
		label.add_theme_font_size_override("font_size", 20)
		label.modulate = Color(0.5, 0.8, 1.0)
	_animate()

func setup_ability(text: String) -> void:
	if label:
		label.text = text
		label.add_theme_font_size_override("font_size", 28)
		label.modulate = Color(1.0, 0.8, 0.0)
		scale = Vector2(1.5, 1.5)
	_animate()

func _animate() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 60, 0.8).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate:a", 0.0, 0.8).set_delay(0.3)
	tween.chain().tween_callback(queue_free)
