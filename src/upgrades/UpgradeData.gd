class_name UpgradeData
extends Resource

# One upgrade the player can pick on level up (Machine Gun, Sniper, ...).
# Make one .tres file per upgrade and set the numbers in the Inspector.

# ---------------- Shown in the level-up menu ----------------
@export var upgrade_name: String = "New Upgrade"
@export_multiline var description: String = ""
@export var icon: Texture2D

# ---------------- Stat changes ----------------
# Multiplies shots per second. 1.5 = 50% faster shooting (buff), 0.8 = slower (nerf)
@export var fire_rate_multiplier: float = 1.0

# Added to spread (degrees). Positive = wider (nerf), negative = tighter (buff)
@export var spread_change: float = 0.0

# Added to bullets per shot. 2 = two extra bullets
@export var bullet_amount_change: int = 0

# Multiplies bullet damage. 2.0 = double damage
@export var damage_multiplier: float = 1.0


# Call this when the player picks this upgrade. Pass in the gun node.
func apply_to(gun: Node) -> void:
	gun.fire_rate = maxf(gun.fire_rate * fire_rate_multiplier, 0.1)
	gun.spread = maxf(gun.spread + spread_change, 0.0)
	gun.bullet_amount = maxi(gun.bullet_amount + bullet_amount_change, 1)
	gun.bullet_damage = maxi(ceili(gun.bullet_damage * damage_multiplier), 1)
