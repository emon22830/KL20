extends RigidBody2D

var hp : int = 0
var max_hp : int = 0

@export var xp_orb_scene: PackedScene = preload("res://src/xp_orb/xp_orb.tscn") 
var is_dead: bool = false 

@onready var sprite := $Sprite
@onready var collider := $Collider


func _ready() -> void:
	SignalBus.take_damage.connect(on_take_damage)
	sprite.autowrap_mode = TextServer.AUTOWRAP_OFF
	sprite.fit_content = true
	await get_tree().process_frame
	check_hp()


func set_hp() -> void:
	sprite.text = str(hp)
	var sprite_size = sprite.get_minimum_size()
	collider.shape.size = sprite_size

func on_take_damage(amount : int) -> void:
	hp -= amount
	check_hp()

func check_hp() -> void:
	if hp <= 0:
		die()
		return
	
	set_hp()

func die() -> void:
	if is_dead:
		return
	is_dead = true

	var orb = xp_orb_scene.instantiate()
	orb.position = global_position
	orb.xp_value = ceili(max_hp / 4.0)
	get_tree().current_scene.add_child.call_deferred(orb)
	GameManager.enemy_list.erase(self)
	
	queue_free()

#func _process(delta: float) -> void:
	#var direction = GameManager.player.position - position 
	#velocity = direction.normalized() * 200
	#move_and_slide()
	#pass

func _physics_process(delta: float) -> void:
	
	if abs(linear_velocity) > Vector2(0.01, 0.01) : 
		linear_velocity += -linear_velocity / 10
		return
	
	#if abs(linear_velocity) < Vector2(0.01, 0.01):
		#print("trying set 0 somehow")
		#linear_velocity = Vector2.ZERO
	
	var direction = GameManager.player.position - position 
	var random_offset = randf_range(-0.3, 0.3)   # radians, adjust spread as needed
	direction = direction.rotated(random_offset)
	direction = direction.normalized()
	apply_central_impulse(direction * 2000)
