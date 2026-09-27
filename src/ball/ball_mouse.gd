@tool
extends Ball
## Follows the mouse cursor.

@export_group("Mouse Follow")
@export var stop_distance := 4.0
@export var slow_radius := 120.0
@export var require_click := false


func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	var target_velocity := Vector2.ZERO
	var to_mouse := get_global_mouse_position() - global_position
	var distance := to_mouse.length()
	var following := not require_click or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if following and distance > stop_distance:
		var arrive_speed := speed * clampf(distance / slow_radius, 0.0, 1.0)
		target_velocity = to_mouse / distance * arrive_speed

	apply_movement(target_velocity, delta)
