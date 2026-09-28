extends CanvasLayer

@onready var xp_label = $Ui/XPLabel


func _process(_delta):
	if not is_instance_valid(GameManager.player):
		return
	update_xp_bar()

func update_xp_bar():
	var player = GameManager.player
	var current_xp = player.exp
	var required_xp = player.max_exp
	var current_level = player.level
	
	var left_bar : String
	var right_bar : String
	
	if required_xp <= 0:
		return
	
	var progress := float(current_xp) / float(required_xp)
	progress = clamp(progress, 0.0, 1.0)
	
	var side_length := 120
	
	var filled := int(progress * side_length)
	var empty := side_length - filled
	
	if empty > side_length / 2:
		var left_empty := empty - side_length / 2
		left_bar = "#".repeat(filled) + "-".repeat(left_empty)
		right_bar = "-".repeat(side_length / 2)
	elif empty == side_length / 2:
		left_bar = "#".repeat(filled)
		right_bar = "-".repeat(side_length / 2)
	elif empty < side_length / 2:
		var right_full := filled - side_length / 2
		left_bar = "#".repeat(side_length / 2)
		right_bar = "#".repeat(right_full) + "-".repeat(empty)
		
	#var left_bar := "#".repeat(filled) + "-".repeat(empty)
	#var right_bar := "-".repeat(empty)
	
	xp_label.text = "[" + left_bar + " " + str(current_level) + " " + right_bar + "]"
