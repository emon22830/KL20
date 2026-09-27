extends Control



@onready var window_options = $CenterContainer/OptionsPanel/VBoxContainer/WindowRow/WindowOption
@onready var fps_option = $CenterContainer/OptionsPanel/VBoxContainer/FPSRow/FPSOption
@onready var vsync_checkbox = $CenterContainer/OptionsPanel/VBoxContainer/VSyncRow/VSyncCheckBox

@onready var brightness_slider = $CenterContainer/OptionsPanel/VBoxContainer/BrightnessRow/BrightnessSlider

@onready var master_volume_slider = $CenterContainer/OptionsPanel/VBoxContainer/MasterVolumeRow/MasterVolumeSlider
@onready var music_volume_slider = $CenterContainer/OptionsPanel/VBoxContainer/MusicVolumeRow/MusicVolumeSlider
@onready var sfx_volume_slider = $CenterContainer/OptionsPanel/VBoxContainer/SFXVolumeRow/SFXVolumeSlider

@onready var back_button = $CenterContainer/OptionsPanel/VBoxContainer/BackButton

func _ready():
	setup_audio_buses()
	
	window_options.item_selected.connect(_window_option_selected)
	fps_option.item_selected.connect(_on_fps_option_selected)
	vsync_checkbox.toggled.connect(_on_vsync_toggled)
	
	brightness_slider.value_changed.connect(_on_brightness_changed)
	_on_brightness_changed(brightness_slider.value)
	
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	
	back_button.pressed.connect(_on_back_button_pressed)

func setup_audio_buses():
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		var music_bus = AudioServer.bus_count - 1
		AudioServer.set_bus_name(music_bus, "Music")
	
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		var sfx_bus = AudioServer.bus_count - 1
		AudioServer.set_bus_name(sfx_bus, "SFX")

func _window_option_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(
				DisplayServer.WINDOW_FLAG_BORDERLESS,
				false
			)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_fps_option_selected(index):
	match index:
		0:
			Engine.max_fps = 30
		
		1:
			Engine.max_fps = 60
		
		2:
			Engine.max_fps = 120
		
		3:
			Engine.max_fps = 0

func _on_vsync_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_brightness_changed(value):
	BrightnessManager.set_brightness(value)

func _on_master_volume_changed(value):
	var bus_index = AudioServer.get_bus_index("Master")
	
	if bus_index != -1:
		AudioServer.set_bus_volume_linear(
			bus_index,
			value / 100.0
		)

func _on_music_volume_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	
	if bus_index != -1:
		AudioServer.set_bus_volume_linear(
			bus_index,
			value / 100.0
		)

func _on_sfx_volume_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	
	if bus_index != -1:
		AudioServer.set_bus_volume_linear(
			bus_index,
			value / 100.0
		)

func _on_back_button_pressed():
	SignalBus.back_pressed.emit()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_on_back_button_pressed()
