@tool
extends Ball

func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	apply_movement(direction * speed, delta)
