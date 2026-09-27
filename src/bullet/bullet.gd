extends Area2D

@export var speed := 1200.0
@export var damage : float = 1
@export var lifetime := 2.0

var direction := Vector2.RIGHT

@onready var label : RichTextLabel = $RichTextLabel

func _ready() -> void:
	rotation = direction.angle()
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.on_take_damage(damage)
		queue_free()
