class_name UpgradePool
extends Resource

# The list of every upgrade that can show up on level up.
# Drag your upgrade .tres files into this array in the Inspector.
@export var upgrades: Array[UpgradeData] = []


# Returns random, different upgrades to show the player (3 by default)
#func get_random_choices(count: int = 3) -> Array[UpgradeData]:
	#var pool: Array[UpgradeData] = upgrades.duplicate()
	#pool.shuffle()
#
	#var choices: Array[UpgradeData] = []
	#for i in mini(count, pool.size()):
		#choices.append(pool[i])
	#return choices

#func get_random_choices() -> UpgradeData:
	#var pool: Array[UpgradeData] = upgrades.duplicate()
	#pool.shuffle()
#
	#return pool[0]
