extends CanvasLayer

var previous_level: int = -1
var level_up_open: bool = false

@onready var level_up_popup = $Ui/LevelPopup
@onready var card_screen = $Ui/CardScreen

@onready var card_button_1 = $Ui/CardScreen/Card1/Card/Button
@onready var card_button_2 = $Ui/CardScreen/Card2/Card/Button
@onready var card_button_3 = $Ui/CardScreen/Card3/Card/Button

func _ready():
	hide()
	
	level_up_popup.hide()
	card_screen.hide()
	
	if is_instance_valid(GameManager.player):
		previous_level = GameManager.player.level
	
	card_button_1.pressed.connect(_on_card_1_pressed)
	card_button_2.pressed.connect(_on_card_2_pressed)
	card_button_3.pressed.connect(_on_card_3_pressed)

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
	
	level_up_popup.show()
	card_screen.hide()
	
	await get_tree().create_timer(1.0, true).timeout
	
	level_up_popup.hide()
	card_screen.show()

func _on_card_1_pressed():
	select_card()

func _on_card_2_pressed():
	select_card()

func _on_card_3_pressed():
	select_card()

func select_card():
	card_screen.hide()
	level_up_open = false
	hide()
	get_tree().paused = false
