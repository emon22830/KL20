extends CharacterBody2D
@export var speed := 300.0
@export var hp : float = 3
@export var colliding_bodies : Array = []

var contacting_enemy : bool = false
var is_invincible: bool = false

func _ready() -> void:
	SignalBus.take_damage.connect(on_take_damage)
	GameManager.player = self

func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	direction = direction.normalized()
	
	velocity = direction * speed
	
	move_and_slide()



func check_enemy_contact() -> void:
	for body in colliding_bodies:
		if body.is_in_group("enemy"):
			on_take_damage(1)

func on_take_damage(amount : float) -> void:
	if is_invincible:
		return
	
	hp -= amount
	if hp <= 0:
			get_tree().change_scene_to_file("res://src/mainmenu/main_menu.tscn")
			return
	
	is_invincible = true
	var timer = get_tree().create_timer(1)
	timer.timeout.connect(_on_iframe_timeout)

func _on_body_entered(body: Node2D) -> void:
	colliding_bodies.append(body)

func _on_iframe_timeout() -> void:
	is_invincible = false
	check_enemy_contact()

func _on_body_exited(body: Node2D) -> void:
	colliding_bodies.erase(body)


func _on_area_entered(area: Area2D) -> void:
	colliding_bodies.append(area)
	check_enemy_contact()


func _on_area_exited(area: Area2D) -> void:
	colliding_bodies.erase(area)
