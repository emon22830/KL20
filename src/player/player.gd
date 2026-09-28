extends CharacterBody2D

@export var speed := 300.0
@export var burst := 1000
@export var temp_burst : int
@export var dashing : bool = false
@export var hp : int = 1
@export var max_hp : int = 1
@export var exp : int = 0
@export var max_exp : int = 1
@export var max_exp_increment : int = 2
@export var level : int = 0
@export var colliding_bodies : Array = []
@export var bullet_scene : PackedScene = preload("res://src/bullet/bullet.tscn")
@export var fire_cooldown := 0.2
@export var muzzle_offset := Vector2(0, -66)
@export var hit_juice_cooldown := 0.25
@export var win_spin : bool = false

@onready var sprite := $Sprite
@onready var collider := $Collider
@onready var hitbox := $Hitbox
@onready var hitbox_collider := $Hitbox/Collider
@onready var gun := $gun


var contacting_enemy : bool = false
var is_invincible: bool = false
var can_shoot : bool = true
var last_hit_juice_time : float = -100.0

var angle := 0.0

func _ready() -> void:
	SignalBus.take_damage.connect(on_take_damage)
	GameManager.player = self
	sprite.autowrap_mode = TextServer.AUTOWRAP_OFF
	sprite.fit_content = true
	check_hp()

func set_hp() -> void:
	sprite.text = str(hp)
	var sprite_size = sprite.get_minimum_size()
	collider.shape.size = sprite_size
	hitbox_collider.shape.size = sprite_size

func _physics_process(_delta):
	if win_spin:
		sprite.pivot_offset = sprite.size / 2
		angle += 3.0 * _delta
		sprite.scale.x = cos(angle)
		for enemy in GameManager.enemy_list:
			enemy.die()
		return
	
	var direction := Vector2.ZERO
	
	if dashing : 
		temp_burst = max(temp_burst - 50, 0)
	
	#if temp_burst <= 0 : 
		#dashing = false
		#temp_burst = 0
	
	
	
	if Input.is_action_just_pressed("dash") && !dashing:
		temp_burst = burst
		dashing = true
		get_tree().create_timer(2).timeout.connect(func(): dashing = false)
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	direction = direction.normalized()
	
	velocity = direction * (speed + temp_burst)
	
	
	
	
	move_and_slide()
	
	if Input.is_action_pressed("cheat"):
		cheat_upgrade()
	
	if !colliding_bodies.is_empty():
		check_contact()

func shoot() -> void:
	can_shoot = false
	get_tree().create_timer(fire_cooldown).timeout.connect(func(): can_shoot = true)
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = (get_global_mouse_position() - bullet.global_position).normalized()
	get_tree().current_scene.add_child(bullet)


func check_contact() -> void:
	for body in colliding_bodies:
		if body.is_in_group("enemy"):
			on_take_damage(1)

func check_hp() -> void:
	if hp <= 0:
		GameManager.enemy_list.clear()
		get_tree().change_scene_to_file("res://src/gameover/game_over.tscn")
		return
	
	set_hp()

func on_take_damage(amount : int) -> void:
	#if is_invincible:
		#return
	
	hp -= amount
	play_hit_juice()
	check_hp()
	
	#is_invincible = true
	#var timer = get_tree().create_timer(1)
	#timer.timeout.connect(_on_iframe_timeout)

func play_hit_juice() -> void:
	var now := Time.get_ticks_msec() / 1000.0
	if now - last_hit_juice_time < hit_juice_cooldown:
		return
	last_hit_juice_time = now

	Juice.play_sfx(Juice.sfx_player_hurt)
	Juice.shake(0.6)
	Juice.screen_flash(Color.RED, 0.7)
	Juice.hit_stop(0.08)
	Juice.bloom_pulse(0.4)
	Juice.flash_sprite(sprite, Color(3, 0.3, 0.3))
	Juice.punch_scale(sprite, 0.3)

func _on_body_entered(body: Node2D) -> void:
	colliding_bodies.append(body)

#func _on_iframe_timeout() -> void:
	#is_invincible = false
	#check_enemy_contact()

func _on_body_exited(body: Node2D) -> void:
	colliding_bodies.erase(body)


func _on_area_entered(area: Area2D) -> void:
	colliding_bodies.append(area)

func _on_area_exited(area: Area2D) -> void:
	colliding_bodies.erase(area)

func add_xp(xp : int) -> void:
	#print(xp)
	
	hp = min(hp + xp, max_hp)
	
	check_hp()
	#set_hp()
	
	
	if exp < max_exp - xp:
		exp += xp
	else:
		max_exp = max_exp * max_exp_increment
		exp = 0
		level += 1
		max_hp = max_exp
		GameManager.enemy_spawner.grow_hp_range()
		gun.upgrade(gun.pick_upgrade())
		if max_hp == -GameManager.INTMAX64 - 1:
			win()
	

func cheat_upgrade() -> void:
	max_exp = GameManager.INTMAX64 / 2 + 1
	max_hp = GameManager.INTMAX64 / 2 + 1
	hp = GameManager.INTMAX64 / 2 + 1
	exp = max_exp - 1
	set_hp()

func win() -> void:
	win_spin = true
	#collider.set_deffered("disabled", true)
	#hitbox_collider.set_deffered("disabled", true)
	collider.queue_free()
	hitbox_collider.queue_free()
	gun.queue_free()
	GameManager.enemy_spawner.queue_free()
	GameManager.player = null
	
	sprite.text = "inf"
	
