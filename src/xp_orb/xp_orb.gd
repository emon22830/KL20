extends Area2D

@export var xp_value: int = 1


@export var magnet_range: float = 600.0

@export var acceleration: float = 900.0

var is_being_pulled: bool = false
var current_speed: float = 0.0
var is_collected: bool = false


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if not is_instance_valid(GameManager.player):
		return

	var player_pos: Vector2 = GameManager.player.global_position

	if global_position.distance_to(player_pos) < magnet_range:
		is_being_pulled = true

	if is_being_pulled:
		current_speed += acceleration * delta
		global_position = global_position.move_toward(player_pos, current_speed * delta)

func collect() -> void:
	if is_collected:
		return
	is_collected = true
	
	if GameManager.player == null : return
	if GameManager.player.has_method("add_xp"):
		GameManager.player.add_xp(xp_value)

	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collect()
