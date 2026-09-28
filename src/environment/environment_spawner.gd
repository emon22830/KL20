extends Node2D

@export var prop_scene: PackedScene = preload("res://src/environment/environment_prop.tscn")

@export var prop_texts: Array[String] = [
	"[color=gray]rock[/color]",
	"[color=dimgray]stone[/color]",
	"[color=forestgreen]tree[/color]",
	"[color=olivedrab]bush[/color]",
	"[color=yellowgreen]grass[/color]",
	"[color=saddlebrown]log[/color]",
]

@export var max_props: int = 40
@export var spawn_interval: float = 0.3

@export var spawn_margin_x: float = 200.0
@export var spawn_margin_y: float = 120.0

@export var despawn_distance_multiplier: float = 1.5

@export var min_scale: float = 0.7
@export var max_scale: float = 1.5
@export var max_rotation_degrees: float = 15.0
@export var min_brightness: float = 0.6

var spawn_timer: Timer


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	fill_screen.call_deferred()


func fill_screen() -> void:
	if not is_instance_valid(GameManager.player):
		return

	var half_size: Vector2 = get_camera_half_size()
	var outer_x: float = half_size.x + spawn_margin_x
	var outer_y: float = half_size.y + spawn_margin_y

	for i in max_props:
		var offset := Vector2(randf_range(-outer_x, outer_x), randf_range(-outer_y, outer_y))
		spawn(GameManager.player.global_position + offset)


func _on_spawn_timer_timeout() -> void:
	if not is_instance_valid(GameManager.player):
		return

	despawn_far_props()

	if get_prop_count() < max_props:
		spawn(random_spawn_position())


func spawn(spawn_position: Vector2) -> void:
	var prop = prop_scene.instantiate()
	prop.add_to_group("environment_prop")
	prop.global_position = spawn_position
	prop.scale = Vector2.ONE * randf_range(min_scale, max_scale)
	prop.rotation = deg_to_rad(randf_range(-max_rotation_degrees, max_rotation_degrees))
	var brightness: float = randf_range(min_brightness, 1.0)
	prop.modulate = Color(brightness, brightness, brightness)
	prop.get_node("Sprite").text = prop_texts.pick_random()
	add_child(prop)


func despawn_far_props() -> void:
	var player_pos: Vector2 = GameManager.player.global_position
	var half_size: Vector2 = get_camera_half_size()
	var max_distance: float = (half_size + Vector2(spawn_margin_x, spawn_margin_y)).length() * despawn_distance_multiplier

	for prop in get_tree().get_nodes_in_group("environment_prop"):
		if prop.global_position.distance_to(player_pos) > max_distance:
			prop.queue_free()


func get_prop_count() -> int:
	return get_tree().get_nodes_in_group("environment_prop").size()


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
