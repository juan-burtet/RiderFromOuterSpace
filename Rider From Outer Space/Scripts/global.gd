extends Node

var heart
var jetpack
var pistol
var shotgun
var machinegun

var upgrades
var coins

func get_hp():
	var x = get_heart()
	return (6 + 2*x)
	pass

func double_jump_height():
	pass

func _ready():
	heart = 3
	jetpack = 0
	pistol = 0
	shotgun = 0
	machinegun = 0
	upgrades = 0
	coins = 0
	pass

func get_upgrades():
	return upgrades

func add_coin():
	coins += 1
	if coins > 99:
		coins = 0
		add_upgrade()

func imprime():
	print("oi")

func add_upgrades():
	upgrades += 1
	if upgrades > 15:
		upgrades = 15

func sub_upgrades():
	upgrades -= 1
	if upgrades < 0:
		upgrades = 0

func get_coins():
	return coins

func get_heart():
	return heart

func get_jetpack():
	return jetpack

func get_pistol():
	return pistol

func get_shotgun():
	return shotgun

func get_machinegun():
	return machinegun

func add_heart():
	heart += 1
	if heart > 3:
		heart = 3
	else:
		sub_upgrades()
		pass

func add_jetpack():
	jetpack += 1
	if jetpack > 3:
		jetpack = 3
	else:
		sub_upgrades()

func add_pistol():
	pistol += 1
	if pistol > 3:
		pistol = 3
	else:
		sub_upgrades()

func add_shotgun():
	shotgun += 1
	if shotgun > 3:
		shotgun = 3
	else:
		sub_upgrades()

func add_machinegun():
	machinegun += 1
	if machinegun > 3:
		machinegun = 3
	else:
		sub_upgrades()