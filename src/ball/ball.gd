@tool
class_name Ball
extends CharacterBody2D

@export_group("Movement")
@export var speed := 300.0
@export var acceleration := 2000.0
@export var friction := 1800.0

@export_group("Look")
@export var radius := 24.0:
	set(value):
		radius = value
		_sync_collision()
		queue_redraw()
@export var color := Color(0.95, 0.45, 0.3):
	set(value):
		color = value
		queue_redraw()
@export var outline_color := Color(0.2, 0.1, 0.1):
	set(value):
		outline_color = value
		queue_redraw()
@export var outline_width := 3.0:
	set(value):
		outline_width = value
		queue_redraw()


func _ready():
	motion_mode = MOTION_MODE_FLOATING 
	_sync_collision()


func apply_movement(target_velocity: Vector2, delta: float):
	var rate := acceleration if target_velocity != Vector2.ZERO else friction
	velocity = velocity.move_toward(target_velocity, rate * delta)
	move_and_slide()


func _draw():
	draw_circle(Vector2.ZERO, radius, color)
	if outline_width > 0.0:
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, outline_color, outline_width, true)
	draw_circle(Vector2(-radius, -radius) * 0.35, radius * 0.22, Color(1, 1, 1, 0.55))


func _sync_collision():
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node and shape_node.shape is CircleShape2D:
		(shape_node.shape as CircleShape2D).radius = radius
