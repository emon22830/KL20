extends Control

@onready var options_menu = $OptionsMenu

func _ready() -> void:
	options_menu.hide()
	SignalBus.back_pressed.connect(_on_option_back_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/main.tscn")

func _on_option_back_pressed():
	options_menu.hide()

func _on_options_pressed() -> void:
	#get_tree().change_scene_to_file("res://src/ui/options/options.tscn")
	options_menu.show()


func _on_exit_pressed() -> void:
	get_tree().quit()
