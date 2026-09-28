extends CharacterBody2D

@export var hp : int = 0
@export var max_hp : int = 0
@export var is_hurt : bool = false
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
	#if hp > 0:
		#Juice.flash_sprite(sprite)
		#Juice.punch_scale(sprite, 0.2)
		#Juice.shake(0.08)
	check_hp()
	is_hurt = true
	get_tree().create_timer(1).timeout.connect(func(): is_hurt = false)

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

	#Juice.death_pop(self, sprite)
	#Juice.shake(0.25)
	#Juice.hit_stop(0.04)
	#Juice.bloom_pulse(0.3)


	queue_free()

func _process(delta: float) -> void:
	var direction = GameManager.player.position - position 
	if is_hurt:
		velocity = direction.normalized() * 100
	else:
		velocity = direction.normalized() * 500
	move_and_slide()
