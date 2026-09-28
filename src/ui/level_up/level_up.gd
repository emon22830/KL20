extends CanvasLayer

var previous_level: int = -1
var level_up_open: bool = false

var gun

var card_upgrade_1: GunStats
var card_upgrade_2: GunStats
var card_upgrade_3: GunStats


@onready var level_up_popup = $Ui/LevelPopup
@onready var card_screen = $Ui/CardScreen
@onready var logo = $Infinite

@onready var card_button_1 = $Ui/CardScreen/Card1/Button
@onready var card_button_2 = $Ui/CardScreen/Card2/Button
@onready var card_button_3 = $Ui/CardScreen/Card3/Button

@onready var card_description_1 = $Ui/CardScreen/Card1/Button/DescLabel
@onready var card_description_2 = $Ui/CardScreen/Card2/Button/DescLabel
@onready var card_description_3 = $Ui/CardScreen/Card3/Button/DescLabel


func _ready():
	hide()
	
	logo.hide()
	level_up_popup.hide()
	card_screen.hide()
	
	if is_instance_valid(GameManager.player):
		previous_level = GameManager.player.level
		gun = GameManager.player.get_node("gun")
	
	card_button_1.pressed.connect(_on_card1_pressed)
	card_button_2.pressed.connect(_on_card2_pressed)
	card_button_3.pressed.connect(_on_card3_pressed)


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
	logo.hide()
	
	await get_tree().create_timer(0.6, true).timeout
	
	level_up_popup.hide()
	
	generate_card_upgrades()
	
	card_screen.show()
	logo.show()


func generate_card_upgrades():
	if gun == null:
		print("No gun upgrade")
		return
	
	if gun.upgrade_pool.size() < 3:
		print("Not enough upgrades")
		return
	
	var upgrades = gun.upgrade_pool.duplicate()
	
	upgrades.shuffle()
	
	card_upgrade_1 = upgrades[0]
	card_upgrade_2 = upgrades[1]
	card_upgrade_3 = upgrades[2]
	
	card_description_1.text = card_upgrade_1.gun_name
	card_description_2.text = card_upgrade_2.gun_name
	card_description_3.text = card_upgrade_3.gun_name
	
	card_description_1.text = get_upgrade_description(card_upgrade_1)
	card_description_2.text = get_upgrade_description(card_upgrade_2)
	card_description_3.text = get_upgrade_description(card_upgrade_3)
	
	print("Card 1: ", card_upgrade_1.gun_name)
	print("Card 2: ", card_upgrade_2.gun_name)
	print("Card 3: ", card_upgrade_3.gun_name)


func _on_card1_pressed():
	gun.upgrade(card_upgrade_1)
	select_card()


func _on_card2_pressed():
	gun.upgrade(card_upgrade_2)
	select_card()


func _on_card3_pressed():
	gun.upgrade(card_upgrade_3)
	select_card()


func select_card():
	card_screen.hide()
	level_up_open = false
	hide()
	get_tree().paused = false

func get_upgrade_description(upgrade: GunStats) -> String:
	var description := ""

	if upgrade.bullet_amount > 0:
		description += "Increase Bullet Amount: +" + str(upgrade.bullet_amount) + "\n"
	if upgrade.bullet_amount < 0:
		description += "Decrease Bullet Amount: " + str(upgrade.bullet_amount) + "\n"

	if upgrade.fire_rate > 0:
		description += "Increase Fire Rate: +" + str(upgrade.fire_rate) + "\n"
	if upgrade.fire_rate < 0:
		description += "Decrease Fire Rate: " + str(upgrade.fire_rate) + "\n"

	if upgrade.bullet_speed > 0:
		description += "Increase Bullet Speed: +" + str(upgrade.bullet_speed) + "\n"
	if upgrade.bullet_speed < 0:
		description += "Decrease Bullet Speed: " + str(upgrade.bullet_speed) + "\n"
	
	if upgrade.spread > 0:
		description += "Increase Spread: +" + str(upgrade.spread) + "\n"
	if upgrade.spread < 0:
		description += "Decrease Spread: " + str(upgrade.spread) + "\n"

	return description.strip_edges()
