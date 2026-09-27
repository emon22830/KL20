extends Node2D

@onready var enemy : PackedScene = preload("res://src/enemy/enemy.tscn")

func _ready() -> void:
	#spawn(1)
	spawn(1000)

func spawn(hp : int = 0) -> void:
	var enemynode = enemy.instantiate()
	enemynode.position = position
	enemynode.hp = hp
	print(enemynode.hp)
	get_tree().current_scene.add_child.call_deferred(enemynode)
	
