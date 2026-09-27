extends Node2D

@onready var enemy : PackedScene = preload("res://src/enemy/enemy.tscn")

func _ready() -> void:
	spawn()

func spawn() -> void:
	var enemynode = enemy.instantiate()
	enemynode.position = position
	get_tree().current_scene.add_child.call_deferred(enemynode)
	
