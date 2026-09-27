extends RichTextLabel

@export_range(0.0, 1.0) var saturation: float = 0.40 
@export_range(0.0, 1.0) var brightness: float = 100 
@export_range(0.0, 1.0) var hue: float = 0.0
@export var rainbow_speed: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	hue = wrapf(hue + rainbow_speed * delta, 0.0, 1.0)
	modulate = Color.from_hsv(hue, saturation, brightness, 1.0)
