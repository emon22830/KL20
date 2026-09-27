extends Node2D

# ---------------- Settings (change these in the Inspector) ----------------
@export var enemy_scene: PackedScene = preload("res://src/enemy/enemy.tscn")

# How often an enemy spawns, in seconds
@export var spawn_interval: float = 1.0

# Extra distance OUTSIDE the camera view where enemies appear.
# Width (left/right) is bigger, height (top/bottom) is a bit smaller.
@export var spawn_margin_x: float = 200.0
@export var spawn_margin_y: float = 120.0

# Enemy number (hp) at the start of the game: random between min and max
@export var start_min_hp: int = 500
@export var start_max_hp: int = 1500

# After EVERY spawn, min and max get multiplied by this.
# 1.03 = +3% per enemy. Bigger value = numbers grow faster.
@export var hp_growth_multiplier: float = 1.03

# ---------------- Runtime values ----------------
var current_min_hp: int
var current_max_hp: int

var spawn_timer: Timer


func _ready() -> void:
	current_min_hp = start_min_hp
	current_max_hp = start_max_hp

	# Timer that spawns an enemy again and again (created only ONCE)
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	# Spawn the first enemy right away
	spawn_next_enemy()


func _on_spawn_timer_timeout() -> void:
	spawn_next_enemy()


func spawn_next_enemy() -> void:
	spawn(get_random_hp())
	grow_hp_range()


func get_random_hp() -> int:
	return randi_range(current_min_hp, current_max_hp)


func grow_hp_range() -> void:
	# ceili() rounds up, so small numbers still grow (e.g. 1 * 1.03 -> 2)
	current_min_hp = ceili(current_min_hp * hp_growth_multiplier)
	current_max_hp = ceili(current_max_hp * hp_growth_multiplier)


func spawn(hp: int = 0) -> void:
	# Don't spawn if the player doesn't exist (e.g. player died)
	if not is_instance_valid(GameManager.player):
		return

	var enemy_node = enemy_scene.instantiate()
	# Assumes the main scene sits at (0, 0), which is the normal setup
	enemy_node.position = random_spawn_position()
	enemy_node.hp = hp
	get_tree().current_scene.add_child.call_deferred(enemy_node)

	# For testing: shows each enemy's number in the Output panel. Remove later.
	print("Spawned enemy with hp: ", hp)


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
