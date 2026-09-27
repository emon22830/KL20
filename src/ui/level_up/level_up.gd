extends CanvasLayer

var previous_level: int = -1
var level_up_open: bool = false

func _ready():
	hide()
	if is_instance_valid(GameManager.player):
		previous_level = GameManager.player.level

func _process(_delta):
	if not is_instance_valid(GameManager.player):
		return
	
	var current_level = GameManager.player.level
	
	if current_level > previous_level:
		previous_level = current_level
		open_level_up()

func open_level_up():
	level_up_open = true
	show()
	get_tree().paused = true
