extends CanvasLayer

@onready var level_label = $Ui/CenterContainer/StatsPanel/VBoxContainer/LevelLabel
@onready var hp_label = $Ui/CenterContainer/StatsPanel/VBoxContainer/HpLabel
@onready var xp_label = $Ui/CenterContainer/StatsPanel/VBoxContainer/XPLabel


func _ready():
	hide()

func _process(_delta):
	if not is_instance_valid(GameManager.player):
		return
	
	var player = GameManager.player
	
	level_label.text = "Level: " + str(player.level)
	hp_label.text = "HP: " + str(player.hp) + " / " + str(player.max_hp)
	xp_label.text = "XP: " + str(player.exp) + " / " + str(player.max_exp)

func _input(event):
	if event.is_action_pressed("show_stats"):
		toggle_stats()

func toggle_stats():
	if visible:
		hide()
		get_tree().paused = false
	else:
		show()
		get_tree().paused = true
