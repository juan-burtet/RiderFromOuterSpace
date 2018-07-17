extends Node

var heart
var jetpack
var pistol
var shotgun
var machinegun

var upgrades
var coins

var loadgame

var map1
var map2
var map3
var map4

signal on
signal off


func get_loadgame():
	return loadgame

func set_loadgame(value):
	loadgame = value

func get_map1():
	return map1

func set_map1():
	map1 = true

func get_map2():
	return map2

func set_map2():
	map2 = true

func get_map3():
	return map3

func set_map3():
	map3 = true

func get_map4():
	return map4

func set_map4():
	map4 = true

func get_hp():
	var x = get_heart()
	return (6 + 2*x)

func _ready():
	map1 = false
	map2 = false
	map3 = false
	map4 = false
	loadgame = null
	heart = 0
	jetpack = 0
	pistol = 0
	shotgun = 0
	machinegun = 0
	upgrades = 0
	coins = 0
	pass

func get_jump_height():
	var height = -500
	return height - get_jetpack()*30
	pass

func get_dash_speed():
	var dash = 1000
	return dash + get_jetpack()*250
	pass


func get_pistol_damage():
	var damage = 25
	return damage + get_pistol() * 10
	pass

func get_shotgun_damage():
	var damage = 60
	return damage + get_shotgun() * 10

func get_machinegun_damage():
	var damage = 5
	return damage + get_machinegun() * 10

func get_upgrades():
	return upgrades

func add_coin():
	coins += 1
	if coins > 99:
		coins = 0
		add_upgrades()

func imprime():
	print("oi")

func check_upgrade():
	if upgrades > 0:
		emit_signal("on")
	elif upgrades == 0:
		emit_signal("off")

func add_upgrades():
	if upgrades == 0:
		emit_signal("on")
	upgrades += 1
	if upgrades > 15:
		upgrades = 15

func sub_upgrades():
	if upgrades == 1:
		emit_signal("off")
	
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