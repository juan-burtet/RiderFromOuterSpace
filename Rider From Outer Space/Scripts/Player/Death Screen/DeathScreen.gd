extends CanvasLayer

const mainMenu = "res://Scenes/Menus/MainMenu.tscn"


var option
var yellow = Color(1,1,0,1)
var white = Color(1,1,1,1)

func _ready():
	option = 0
	pass

func _process(delta):
	# move o menu
	move_option()
	# esta em cima da opcao
	in_option()
	# escolhe a opcao
	select_option()
	pass

func move_option():
	if Input.is_action_just_pressed("ui_upMenu"):
		option -= 1
	elif Input.is_action_just_pressed("ui_downMenu"):
		option += 1
	
	if option > 1:
		option = 0
	elif option < 0:
		option = 1

func in_option():
	match option:
		0: 
			$Options/Continue.set_modulate(yellow)
			$Options/GoMenu.set_modulate(white)
		1: 
			$Options/Continue.set_modulate(white)
			$Options/GoMenu.set_modulate(yellow)

func select_option():
	if Input.is_action_just_pressed("ui_accept"):
		match option:
			0: returnGame()
			1: goMenu()

func returnGame():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func goMenu():
	get_tree().paused = false
	get_tree().change_scene(mainMenu)
	queue_free()