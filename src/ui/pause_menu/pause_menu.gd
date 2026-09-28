extends CanvasLayer

@onready var pause_overlay = $PauseOverlay
@onready var options_menu = $Options

@onready var pause_button = $GameUi/PauseButton

func _ready():
	pause_overlay.hide()
	options_menu.hide()
	
	SignalBus.back_pressed.connect(_on_option_back_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if options_menu.visible:
			_on_option_back_pressed()
		else:
			toggle_pause()

func toggle_pause():
	var is_paused = get_tree().paused
	
	get_tree().paused = !is_paused
	pause_overlay.visible = !is_paused
	pause_button.visible = is_paused

func _on_pause_button_pressed() -> void:
	toggle_pause()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_option_back_pressed():
	options_menu.hide()
	pause_overlay.show()

func _on_option_button_pressed() -> void:
	pause_overlay.hide()
	options_menu.show()


func _on_main_menu_pressed() -> void:
	#get_tree().current_scene = mainMenu
	#get_tree().current_scene.queue_free()\
	toggle_pause()
	for sfx in GameManager.sfx_player:
		sfx.stop()
	get_tree().change_scene_to_file("res://src/mainmenu/main_menu.tscn")
