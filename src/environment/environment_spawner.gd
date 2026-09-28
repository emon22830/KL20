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

@export var max_props: int = 70
@export var spawn_interval: float = 0.3


@export var spawn_margin: float = 400.0
@export var despawn_extra: float = 200.0

@export var min_prop_distance: float = 200.0
@export var placement_attempts: int = 8

@export var min_scale: float = 0.7
@export var max_scale: float = 1.4
@export var min_brightness: float = 0.45
@export var max_brightness: float = 0.8
@export var max_rotation_degrees: float = 12.0

var spawn_timer: Timer


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

	fill_area.call_deferred()


func fill_area() -> void:
	if not is_instance_valid(GameManager.player):
		return
	top_up(false)


func _on_spawn_timer_timeout() -> void:
	if not is_instance_valid(GameManager.player):
		return

	despawn_far_props()
	top_up(true)


func top_up(off_screen_only: bool) -> void:
	var missing: int = max_props - get_prop_count()
	for i in missing:
		var spot = find_spawn_spot(off_screen_only)
		if spot == null:
			return
		spawn(spot)


func find_spawn_spot(off_screen_only: bool):
	var player_pos: Vector2 = GameManager.player.global_position
	var half_size: Vector2 = get_camera_half_size()
	var radius: float = get_spawn_radius()

	for attempt in placement_attempts:
		var offset := Vector2.from_angle(randf() * TAU) * radius * sqrt(randf())
		if off_screen_only and abs(offset.x) < half_size.x and abs(offset.y) < half_size.y:
			continue
		var spot: Vector2 = player_pos + offset
		if is_spot_free(spot):
			return spot
	return null


func is_spot_free(spot: Vector2) -> bool:
	for prop in get_tree().get_nodes_in_group("environment_prop"):
		if prop.global_position.distance_to(spot) < min_prop_distance:
			return false
	return true


func spawn(spawn_position: Vector2) -> void:
	var prop = prop_scene.instantiate()
	prop.add_to_group("environment_prop")
	prop.global_position = spawn_position

	var depth: float = randf()
	prop.scale = Vector2.ONE * lerpf(min_scale, max_scale, depth)
	var brightness: float = lerpf(min_brightness, max_brightness, depth)
	prop.modulate = Color(brightness, brightness, brightness)
	prop.rotation = deg_to_rad(randf_range(-max_rotation_degrees, max_rotation_degrees))

	prop.get_node("Sprite").text = prop_texts.pick_random()
	add_child(prop)


func despawn_far_props() -> void:
	var player_pos: Vector2 = GameManager.player.global_position
	var max_distance: float = get_spawn_radius() + despawn_extra

	for prop in get_tree().get_nodes_in_group("environment_prop"):
		if prop.global_position.distance_to(player_pos) > max_distance:
			prop.remove_from_group("environment_prop")
			prop.queue_free()


func get_prop_count() -> int:
	return get_tree().get_nodes_in_group("environment_prop").size()


func get_spawn_radius() -> float:
	return get_camera_half_size().length() + spawn_margin


func get_camera_half_size() -> Vector2:
	var view_size: Vector2 = get_viewport().get_visible_rect().size
	var camera := get_viewport().get_camera_2d()

	if camera:
		view_size /= camera.zoom

	return view_size / 2.0
