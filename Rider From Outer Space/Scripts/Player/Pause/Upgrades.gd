extends Node

# Imagens
const LIFE_IMAGE = "Life"
const JETPACK_IMAGE = "Jetpack"
const PISTOL_IMAGE = "Pistol"
const SHOTGUN_IMAGE = "Shotgun"
const MACHINE_GUN_IMAGE = "MachineGun"


# Nomes
const LIFE_NAME = "LIFE"
const JETPACK_NAME = "JETPACK"
const PISTOL_NAME = "PISTOL"
const SHOTGUN_NAME = "SHOTGUN"
const MACHINE_GUN_NAME = "MACHINE GUN"

# Descrições
const LIFE_DESCRIPTION = "UPGRADE THIS TO GET 1 MORE HEART"
const JETPACK_DESCRIPTION = "UPGRADE THIS TO JUMP HIGHER"
const PISTOL_DESCRIPTION = "UPGRADE THIS TO DO MORE DAMAGE WITH THE PISTOL"
const SHOTGUN_DESCRIPTION = "UPGRADE THIS TO DO MORE DAMAGE WITH THE SHOTGUN"
const MACHINE_GUN_DESCRIPTION = "UPGRADE THIS TO DO MORE DAMAGE WITH THE MACHINE GUN"

# Option
var option 

signal saiu
signal aumentou_hp

onready var timer = $Timer

func _ready():
	var player = get_parent()
	player = player.get_parent()
	connect("aumentou_hp", player, "on_aumentou_hp")
	option = 0
	set_option()
	pass

func _process(delta):
	# move a opcao
	move_option()
	
	#atualiza o valor
	$n_upgrades/qt.set_text(str(global.get_upgrades()))
	
	
	if Input.is_action_just_pressed("ui_accept"):
		choose_option()
	
	update_points()
	pass

func update_points():
	
	update_sprite($Points/Life, global.get_heart())
	update_sprite($Points/Jetpack, global.get_jetpack())
	update_sprite($Points/Pistol, global.get_pistol())
	update_sprite($Points/Shotgun, global.get_shotgun())
	update_sprite($Points/MachineGun, global.get_machinegun())
	
	pass


func update_sprite(sprite, value):
	sprite.play(str(value))
	#match value:
	#	0:pass
	#	1:pass
	#	2:pass
	#	3:pass
	pass


func choose_option():
	if global.get_upgrades() < 1:
		$Animation.play("machinegun")
	else:
		match option:
			0:
				emit_signal("aumentou_hp")
				global.add_heart()
				pass
			1:
				global.add_jetpack()
				pass
			2:
				global.add_pistol()
				pass
			3:
				global.add_shotgun()
				pass
			4:
				global.add_machinegun()
				pass
		pass
	pass



func _input(event):
	if event.is_action_pressed("ui_esc"):
		timer.set_one_shot(true)
		timer.set_wait_time(0.1)
		timer.start()
		yield(timer,"timeout")
		emit_signal("saiu")
		queue_free()

# movimenta uma opcao
func move_option():
	var up = Input.is_action_just_pressed("ui_upMenu")
	var down = Input.is_action_just_pressed("ui_downMenu")
	var left = Input.is_action_just_pressed("ui_leftMenu")
	var right = Input.is_action_just_pressed("ui_rightMenu")
	
	if left:
		option -= 1
		if option < 0:
			option = 4
	elif right:
		option += 1
		if option > 4:
			option = 0
	elif up or down:
		match option:
			0: option = 2
			1: option = 4
			2: option = 0
			3: option = 0
			4: option = 1
	else:
		return
	
	set_option()
	
	pass

# Escolhe a opção que vai ser escolhida na tela
func set_option():
	match option:
		0: set_image_and_text(LIFE_IMAGE, LIFE_NAME, LIFE_DESCRIPTION)
		1: set_image_and_text(JETPACK_IMAGE, JETPACK_NAME, JETPACK_DESCRIPTION)
		2: set_image_and_text(PISTOL_IMAGE, PISTOL_NAME, PISTOL_DESCRIPTION)
		3: set_image_and_text(SHOTGUN_IMAGE, SHOTGUN_NAME, SHOTGUN_DESCRIPTION)
		4: set_image_and_text(MACHINE_GUN_IMAGE, MACHINE_GUN_NAME, MACHINE_GUN_DESCRIPTION)
	pass

# Seta a Info da opcao
func set_image_and_text(image, name, description):
	$Background.play(image)
	$Info/Image.play(image)
	$Info/Name.set_text(name)
	$Info/Description.set_bbcode(description)