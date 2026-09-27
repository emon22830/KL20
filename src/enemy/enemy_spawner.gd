extends Node2D

# ---------------- Settings (change these in the Inspector) ----------------
@export var enemy_scene: PackedScene = preload("res://src/enemy/enemy.tscn")

# How often an enemy spawns, in seconds
@export var spawn_interval: float = 1.0

# Extra distance OUTSIDE the camera view where enemies appear.
# Width (left/right) is bigger, height (top/bottom) is a bit smaller.
@export var spawn_margin_x: float = 200.0
@export var spawn_margin_y: float = 120.0

var spawn_timer: Timer


func _ready() -> void:
	#spawn(1)
	spawn(1000)

func spawn(hp : int = 0) -> void:
	var enemynode = enemy.instantiate()
	enemynode.position = position
	enemynode.hp = hp
	print(enemynode.hp)
	get_tree().current_scene.add_child.call_deferred(enemynode)
	
=======
	# Timer that calls spawn() again and again
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(spawn)
	add_child(spawn_timer)


func spawn() -> void:
	# Don't spawn if the player doesn't exist (e.g. player died)
	if not is_instance_valid(GameManager.player):
		return

	var enemy_node = enemy_scene.instantiate()
	# Assumes the main scene sits at (0, 0), which is the normal setup
	enemy_node.position = random_spawn_position()
	get_tree().current_scene.add_child.call_deferred(enemy_node)


func random_spawn_position() -> Vector2:
	var player_pos: Vector2 = GameManager.player.global_position
	var half_size: Vector2 = get_camera_half_size()

	# The spawn rectangle = camera view + margin on every side
	var outer_x: float = half_size.x + spawn_margin_x
	var outer_y: float = half_size.y + spawn_margin_y

	var offset := Vector2.ZERO

	# Pick one of the 4 sides at random, then a random point along that side
	match randi() % 4:
		0: # top
			offset = Vector2(randf_range(-outer_x, outer_x), -outer_y)
		1: # bottom
			offset = Vector2(randf_range(-outer_x, outer_x), outer_y)
		2: # left
			offset = Vector2(-outer_x, randf_range(-outer_y, outer_y))
		3: # right
			offset = Vector2(outer_x, randf_range(-outer_y, outer_y))

	return player_pos + offset


func get_camera_half_size() -> Vector2:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var camera := get_viewport().get_camera_2d()

	# If the camera is zoomed, the visible area changes size
	if camera:
		view_size /= camera.zoom

	return view_size / 2.0
>>>>>>> Stashed changes
