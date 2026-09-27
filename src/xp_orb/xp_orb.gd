extends Area2D

# ---------------- Settings (change these in the Inspector) ----------------
# How much XP this orb gives
@export var xp_value: int = 1

# When the player is closer than this, the orb starts flying to them
@export var magnet_range: float = 150.0

# How fast the orb speeds up while flying (keeps accelerating,
# so it always catches the player)
@export var acceleration: float = 900.0

# ---------------- Runtime values ----------------
var is_being_pulled: bool = false
var current_speed: float = 0.0
var is_collected: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(GameManager.player):
		return

	var player_pos: Vector2 = GameManager.player.global_position

	# Once the player gets close, the orb stays pulled even if they walk away
	if global_position.distance_to(player_pos) < magnet_range:
		is_being_pulled = true

	if is_being_pulled:
		current_speed += acceleration * delta
		global_position = global_position.move_toward(player_pos, current_speed * delta)


func _on_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		collect()


func collect() -> void:
	# Stops the orb from being collected twice in the same frame
	if is_collected:
		return
	is_collected = true

	if GameManager.player.has_method("add_xp"):
		GameManager.player.add_xp(xp_value)

	queue_free()
