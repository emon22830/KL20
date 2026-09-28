extends Control
func _ready() -> void:
	for sfx in GameManager.sfx_player:
		sfx.stop()
	Juice.play_sfx(Juice.game_over_music)
func _on_retry_pressed() -> void:
	for sfx in GameManager.sfx_player:
		sfx.stop()
	get_tree().change_scene_to_file("res://src/main/main.tscn")

func _on_main_menu_pressed() -> void:
	for sfx in GameManager.sfx_player:
		sfx.stop()
	get_tree().change_scene_to_file("res://src/mainmenu/main_menu.tscn")
