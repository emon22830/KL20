extends CanvasLayer

const BUFF_COLOR := "#4ade80"
const NERF_COLOR := "#f87171"

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

@onready var card_description_1: RichTextLabel = $Ui/CardScreen/Card1/Button/DescLabel
@onready var card_description_2: RichTextLabel = $Ui/CardScreen/Card2/Button/DescLabel
@onready var card_description_3: RichTextLabel = $Ui/CardScreen/Card3/Button/DescLabel


func _ready():
	hide()
	
	logo.hide()
	level_up_popup.hide()
	card_screen.hide()
	
	# Make sure BBCode is on even if it was missed in the Inspector
	for label in [card_description_1, card_description_2, card_description_3]:
		label.bbcode_enabled = true
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
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
	var lines: Array[String] = []
	
	# Higher is better
	_add_stat_line(lines, "Bullet Amount", upgrade.bullet_amount)
	_add_stat_line(lines, "Fire Rate", upgrade.fire_rate)
	_add_stat_line(lines, "Bullet Speed", upgrade.bullet_speed)
	
	# Lower is better
	_add_stat_line(lines, "Spread", upgrade.spread, true)
	
	return "\n".join(lines)


func _add_stat_line(lines: Array[String], stat_name: String, value: float, lower_is_better := false) -> void:
	if value == 0:
		return
	
	var is_increase := value > 0
	var is_buff := is_increase != lower_is_better
	var color := BUFF_COLOR if is_buff else NERF_COLOR
	var verb := "Increase" if is_increase else "Decrease"
	var sign := "+" if is_increase else ""
	
	lines.append("[color=%s]%s %s: %s%s[/color]" % [color, verb, stat_name, sign, str(value)])
