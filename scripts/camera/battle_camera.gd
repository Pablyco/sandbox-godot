extends Camera2D

const ZOOM_MIN = Vector2(0.3, 0.3)
const ZOOM_MAX = Vector2(2.0, 2.0)
const ZOOM_SPEED = 0.1
const DRAG_SPEED = 0.5

var is_dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO

func _ready() -> void:
	make_current()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_out()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			is_dragging = event.pressed
			drag_start = event.position

	if event is InputEventMouseMotion and is_dragging:
		var delta = (event.position - drag_start) * DRAG_SPEED / zoom.x
		position -= delta
		drag_start = event.position

func _zoom_in() -> void:
	var new_zoom = zoom * (1.0 + ZOOM_SPEED)
	new_zoom = new_zoom.clamp(ZOOM_MIN, ZOOM_MAX)
	var tween = create_tween()
	tween.tween_property(self, "zoom", new_zoom, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _zoom_out() -> void:
	var new_zoom = zoom * (1.0 - ZOOM_SPEED)
	new_zoom = new_zoom.clamp(ZOOM_MIN, ZOOM_MAX)
	var tween = create_tween()
	tween.tween_property(self, "zoom", new_zoom, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
