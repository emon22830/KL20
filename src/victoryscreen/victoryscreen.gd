extends Control

@onready var sfx_victory_fanfare_final_fantasy := $AudioStreamPlayer
@onready var flying_box: VBoxContainer = $VBoxContainer
@export var slide_duration: float = 3.5

var angle := 0.0
var target_end_pos := Vector2.ZERO
var is_animating := true

var win = false;

func _ready() -> void:
	SignalBus.game_win.connect(owo)



func _process(delta: float) -> void:
	if is_animating and win:
		angle += 5.0 * delta 
		flying_box.scale.x = cos(angle)
	else:
		flying_box.scale.x = move_toward(flying_box.scale.x, 1.0, delta * 4.0)


func owo() ->void:
	win = true;
	show()

	for sfx in GameManager.sfx_player:
		sfx.stop()
	sfx_victory_fanfare_final_fantasy.play()

	var viewport_size := get_viewport_rect().size
	var target_x := viewport_size.x / 2.0
	var target_y := viewport_size.y / 2.0
	
	flying_box.pivot_offset = flying_box.size / 2.0
	
	var start_pos := Vector2(target_x - (flying_box.size.x / 2.0), -flying_box.size.y)
	target_end_pos = Vector2(target_x - (flying_box.size.x / 2.0), target_y - (flying_box.size.y / 2.0))
	
	flying_box.position = start_pos
	
	var tween := create_tween()
	tween.tween_property(flying_box, "position", target_end_pos, slide_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	tween.finished.connect(func(): is_animating = false)
