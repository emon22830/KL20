extends Node2D

@export var enemy_scene: PackedScene = preload("res://src/enemy/enemy.tscn")

@export var spawn_interval: float = 1.0

@export var spawn_margin_x: float = 200.0
@export var spawn_margin_y: float = 120.0

@export var start_min_hp: int = 1
@export var start_max_hp: int = 1

@export var hp_growth_multiplier: float = 2

var current_min_hp: int
var current_max_hp: int

var spawn_timer : Timer


func _ready() -> void:
	GameManager.enemy_spawner = self
	enemy_max_set()
	
	current_min_hp = start_min_hp
	current_max_hp = start_max_hp

	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	spawn(get_random_hp())

func enemy_max_set() -> void:
	if nearest_po2(current_min_hp) <= 0:
		GameManager.enemy_max_count = 5
		return
	
	GameManager.enemy_max_count = log(nearest_po2(current_min_hp)) + 5

func _on_spawn_timer_timeout() -> void:
	spawn(get_random_hp())


func get_random_hp() -> int:
	return randi_range(current_min_hp, current_max_hp)


func grow_hp_range() -> void:
	current_max_hp = ceili(current_max_hp * hp_growth_multiplier)
	current_min_hp = ceili(current_max_hp / hp_growth_multiplier / 2)
	enemy_max_set()
	


func spawn(hp: int = 0) -> void:
	#print("spawning")
	
	if not is_instance_valid(GameManager.player):
		return
	
	if GameManager.enemy_list.size() >= GameManager.enemy_max_count:
		#print(GameManager.enemy_list.size())
		#print(GameManager.enemy_max_count)
		return

	var enemy_node = enemy_scene.instantiate()
	enemy_node.position = random_spawn_position()
	enemy_node.hp = hp
	get_tree().current_scene.add_child.call_deferred(enemy_node)
	GameManager.enemy_list.append(enemy_node)


func random_spawn_position() -> Vector2:
	var player_pos: Vector2 = GameManager.player.global_position
	var half_size: Vector2 = get_camera_half_size()

	var outer_x: float = half_size.x + spawn_margin_x
	var outer_y: float = half_size.y + spawn_margin_y

	var offset := Vector2.ZERO

	match randi() % 4:
		0: 
			offset = Vector2(randf_range(-outer_x, outer_x), -outer_y)
		1: 
			offset = Vector2(randf_range(-outer_x, outer_x), outer_y)
		2:
			offset = Vector2(-outer_x, randf_range(-outer_y, outer_y))
		3: 
			offset = Vector2(outer_x, randf_range(-outer_y, outer_y))

	return player_pos + offset


func get_camera_half_size() -> Vector2:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var camera := get_viewport().get_camera_2d()

	if camera:
		view_size /= camera.zoom

	return view_size / 2.0
