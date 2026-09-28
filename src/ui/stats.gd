extends CanvasLayer

@onready var level_label = $Ui/CenterContainer/StatsPanel/HBoxContainer/PlayerStat/Stat/LevelLabel
@onready var hp_label = $Ui/CenterContainer/StatsPanel/HBoxContainer/PlayerStat/Stat/HpLabel
@onready var xp_label = $Ui/CenterContainer/StatsPanel/HBoxContainer/PlayerStat/Stat/XPLabel

@onready var gun_name = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/GunName
@onready var bullet_dmg = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/BulletDamage
@onready var fire_rate = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/FireRate
@onready var bullet_amt = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/BulletAmount
@onready var bullet_spd = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/BulletSpeed
@onready var spread = $Ui/CenterContainer/StatsPanel/HBoxContainer/GunStat/Stat/Spread

func _ready():
	hide()

func _process(_delta):
	if not is_instance_valid(GameManager.player):
		return
	
	var player = GameManager.player
	var guns = get_tree().get_nodes_in_group("gun")
	
	level_label.text = "Level: " + str(player.level)
	hp_label.text = "HP: " + str(player.hp) + " / " + str(player.max_hp)
	xp_label.text = "XP: " + str(player.exp) + " / " + str(player.max_exp)
	
	if guns.size() > 0:
		var gun = guns[0]
		gun_name.text = "Guns" + gun.stats.gun_name
		bullet_dmg.text = "Bullet Damage: " + str(gun.bullet_damage)
		fire_rate.text = "Fire Rate: " + str(gun.fire_rate)
		bullet_amt.text = "Bullet Amount: " + str(gun.bullet_amount)
		bullet_spd.text = "Bullet Speed: " + str(gun.bullet_speed)
		spread.text = "Spread Amount: " + str(gun.spread)

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
