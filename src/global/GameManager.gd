extends Node

@onready var player : Node2D
const INTMAX64 : int = 9223372036854775807
@onready var enemy_spawner : Node2D
var enemy_max_count : int
var enemy_list : Array[Node2D]
