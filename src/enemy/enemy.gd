extends Area2D

var hp : int = 0

@onready var sprite := $Sprite
@onready var collider := $Collider


func _ready() -> void:
	SignalBus.take_damage.connect(on_take_damage)
	sprite.autowrap_mode = TextServer.AUTOWRAP_OFF
	sprite.fit_content = true
	check_hp()


func set_hp() -> void:
	sprite.text = str(hp)
	var sprite_size = sprite.get_minimum_size()
	collider.shape.size = sprite_size
	#collider.position = sprite.position / 2

func on_take_damage(amount : float) -> void:
	hp -= amount
	check_hp()

func check_hp() -> void:
	print("enemy checking hp :" + str(hp))
	if hp <= 0:
		self.queue_free()
		return
	
	set_hp()

func _process(delta: float) -> void:
	var direction = GameManager.player.position - position 
	position += direction.normalized() * 2
	on_take_damage(10)
	pass
