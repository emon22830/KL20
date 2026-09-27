extends Area2D

@onready var hp : float = 3

func _ready() -> void:
	SignalBus.take_damage.connect(on_take_damage)
	#print(get_groups())

func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#body.on_take_damage(1.0)
	pass

func on_take_damage(amount : float):
	hp -= amount
	if hp <= 0:
		self.queue_free()

func _process(delta: float) -> void:
	var direction = GameManager.player.position - position 
	position += direction.normalized() * 2
	pass
