extends Area2D

@export var speed := 1200.0
@export var damage : float = 1
@export var lifetime := 2.0

var direction := Vector2.RIGHT

@onready var sprite : RichTextLabel = $Sprite
@onready var collidor :CollisionShape2D = $Collider

func _ready() -> void:
	sprite.fit_content = true
	sprite.autowrap_mode = TextServer.AUTOWRAP_OFF
	rotation = direction.angle()
	collidor.shape.size.x = sprite.get_minimum_size().x
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.on_take_damage(damage)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.on_take_damage(damage)
		queue_free()
