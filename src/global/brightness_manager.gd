extends CanvasLayer

@onready var overlay = $ColorRect

func set_brightness(value: float) -> void:
	var brightness = value / 100.0
	var max_darkness = 0.75  
	var alpha = (1.0 - brightness) * max_darkness
	overlay.color = Color(0, 0, 0, alpha)
