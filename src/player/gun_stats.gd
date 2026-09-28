class_name GunStats
extends Resource

# Values that get ADDED to the gun by gun.add_upgrade().
# Positive = more, negative = less, 0 = no change.

@export var gun_name: String = "Upgrade"

@export var bullet_amount: int = 0
@export var bullet_damage: int = 0
@export var fire_rate: float = 0.0
@export var bullet_speed: float = 0.0
@export var spread: float = 0.0

# Seconds added to how long bullets live (longer = more range)
@export var bullet_lifetime: float = 0.0
