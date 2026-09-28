extends Control

@export var hover_scale := 1.08
@export var press_scale := 0.94
@export var duration := 0.12

@onready var parent = $".."

func _ready() -> void:
	resized.connect(_update_pivot)
	_update_pivot()
	
	mouse_entered.connect(_on_entered)
	mouse_exited.connect(_on_exited)

func _on_entered():
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(parent, "scale", Vector2.ONE * hover_scale, duration)

func _on_exited():
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(parent, "scale", Vector2.ONE, duration)
	Juice.play_sfx(Juice.card_pick_sfx)

func _update_pivot():
	parent.pivot_offset = size / 2.0
