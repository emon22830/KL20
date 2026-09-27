extends Control

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/main.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/mainmenu/main_menu.tscn")
