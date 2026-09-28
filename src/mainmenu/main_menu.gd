extends Control

@onready var options_menu = $OptionsMenu

func _ready() -> void:
	options_menu.hide()
	SignalBus.back_pressed.connect(_on_option_back_pressed)
	
	Juice.play_sfx(Juice.main_menu_music)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/main.tscn")
	for sfx in GameManager.sfx_player:
		sfx.stop()

func _on_option_back_pressed():
	options_menu.hide()

func _on_options_pressed() -> void:
	#get_tree().change_scene_to_file("res://src/ui/options/options.tscn")
	options_menu.show()


func _on_exit_pressed() -> void:
	get_tree().quit()
