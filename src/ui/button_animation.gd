extends Button

@export var hover_scale := 1.08
@export var press_scale := 0.94
@export var duration := 0.12

func _ready():
	
	resized.connect(_update_pivot)
	_update_pivot()
	
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)
	button_down.connect(_on_down)
	button_up.connect(_on_up)

func _on_hover():
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE * hover_scale, duration)
	Juice.play_sfx(Juice.sfx_button_ding)
	

func _on_exit():
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE, duration)
	Juice.play_sfx(Juice.sfx_button_ding)

func _on_down():
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE * press_scale, 0.06)
	Juice.play_sfx(Juice.sfx_button_ding)


func _on_up():
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT) \
		.tween_property(self, "scale", Vector2.ONE * hover_scale, 0.12)
	Juice.play_sfx(Juice.sfx_button_ding)

func _update_pivot():
	pivot_offset = size / 2.0
