class_name GunStats
extends Resource

# A preset of gun numbers. Make .tres files from this to create different guns.

@export var gun_name: String = "Basic Gun"

# How many bullets come out per shot
@export var bullet_amount: int = 1

# How much each bullet reduces an enemy's number
@export var bullet_damage: int = 1

# Shots per second (5.0 = one shot every 0.2 seconds)
@export var fire_rate: float = 5.0

# How fast bullets fly
@export var bullet_speed: float = 1200.0

# Total angle (in degrees) the bullets fan out over when bullet_amount > 1
@export var spread: float = 20.0
