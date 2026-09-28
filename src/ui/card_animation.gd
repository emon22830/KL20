extends Control

@export var hover_scale := 1.08
@export var press_scale := 0.94
@export var duration := 0.12

func _ready() -> void:
	
	mouse_entered.connect(_on_entered)
	mouse_exited.connect(_on_exited)

func _on_entered():
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE * hover_scale, duration)

func _on_exited():
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE, duration)
