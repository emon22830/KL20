extends Node2D

# ---------------- Settings ----------------
# Drag a preset (.tres) here in the Inspector
@export var upgrade_pool : Array[GunStats]
@export var bullet_scene: PackedScene = preload("res://src/bullet/bullet.tscn")

# ---------------- Runtime values (upgrades change these) ----------------
@export var stats: GunStats
var bullet_amount: int
var bullet_damage: int
var fire_rate: float
var bullet_speed: float
var spread: float

# Time left until the gun can shoot again
var cooldown_left: float = 0.0


func _ready() -> void:
	if stats == null : return
	upgrade.call_deferred(stats)

func pick_upgrade() -> GunStats:
	var upgrade_dupe := upgrade_pool.duplicate()
	upgrade_dupe.shuffle()
	return upgrade_dupe[0]

func upgrade(new_stats: GunStats) -> void:
	stats = new_stats
	bullet_amount += stats.bullet_amount
	bullet_damage = GameManager.enemy_spawner.current_min_hp / 4
	fire_rate += stats.fire_rate
	bullet_speed += stats.bullet_speed
	spread += stats.spread
	
	if bullet_amount < 1 : bullet_amount = 1


func _physics_process(delta: float) -> void:
	cooldown_left -= delta

	if Input.is_action_pressed("shoot") and cooldown_left <= 0.0:
		shoot()
		cooldown_left = 1.0 / fire_rate


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
	if spread <= 0 : return 0
	return randf_range(-spread, spread)
