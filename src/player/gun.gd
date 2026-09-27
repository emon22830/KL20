extends Node2D

# ---------------- Settings ----------------
# Drag a preset (.tres) here in the Inspector
@export var starting_stats: GunStats
@export var bullet_scene: PackedScene = preload("res://src/bullet/bullet.tscn")

# ---------------- Runtime values (upgrades change these) ----------------
var stats: GunStats
var bullet_amount: int
var bullet_damage: int
var fire_rate: float
var bullet_speed: float
var spread: float

# Time left until the gun can shoot again
var cooldown_left: float = 0.0


func _ready() -> void:
	set_gun_type(starting_stats)


func set_gun_type(new_stats: GunStats) -> void:
	stats = new_stats
	bullet_amount = stats.bullet_amount
	bullet_damage = stats.bullet_damage
	fire_rate = stats.fire_rate
	bullet_speed = stats.bullet_speed
	spread = stats.spread


func _physics_process(delta: float) -> void:
	cooldown_left -= delta

	#if Input.is_action_pressed("shoot") and cooldown_left <= 0.0:
		#shoot()
		#cooldown_left = 1.0 / fire_rate


func shoot() -> void:
	var aim_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	for i in bullet_amount:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = aim_direction.rotated(deg_to_rad(get_spread_offset(i)))
		bullet.damage = bullet_damage
		bullet.speed = bullet_speed
		get_tree().current_scene.add_child(bullet)


# Spreads the bullets evenly across the spread angle.
# 1 bullet: straight at the mouse. 3 bullets with 20 spread: -10, 0, +10 degrees.
func get_spread_offset(index: int) -> float:
	if bullet_amount <= 1:
		return 0.0
	var step: float = spread / (bullet_amount - 1)
	return -spread / 2.0 + step * index


# ---------------- Upgrades (call these from your level-up screen) ----------------

func add_bullet_amount(amount: int) -> void:
	bullet_amount += amount


func add_bullet_damage(amount: int) -> void:
	bullet_damage += amount


func multiply_bullet_damage(multiplier: float) -> void:
	bullet_damage = ceili(bullet_damage * multiplier)


func multiply_fire_rate(multiplier: float) -> void:
	fire_rate *= multiplier


func add_bullet_speed(amount: float) -> void:
	bullet_speed += amount


func add_spread(amount: float) -> void:
	spread += amount
