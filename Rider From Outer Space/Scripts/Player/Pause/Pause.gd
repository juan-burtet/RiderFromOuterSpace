# Pause.gd
extends CanvasLayer

const mainMenu = "res://Scenes/Menus/MainMenu.tscn"


var option
var yellow = Color(1,1,0,1)
var white = Color(1,1,1,1)

func _ready():
	option = 0
	pass

func _process(delta):
	# Pinta todos opcoes de branco
	modulate_options()
	
	# Move a opcao escolhida
	move_options()
	
	# Pinta opcao escolhida de Amarelo
	modulate_choice()
	
	# Escolhe a opcao
	pick_option()
	
	pass

# Pinta as opcoes de branco
func modulate_options():
	$ReturnGame.set_modulate(white)
	$Stats.set_modulate(white)
	$Quit.set_modulate(white)
	pass

# Pinta a opcao escolhida de amarelo
func modulate_choice():
	match option:
		0: $ReturnGame.set_modulate(yellow)
		1: $Stats.set_modulate(yellow)
		2: $Quit.set_modulate(yellow)
	pass

# Move a opcao do menu
func move_options():
	var up = Input.is_action_just_pressed("ui_upMenu")
	var down = Input.is_action_just_pressed("ui_downMenu")
	
	if up:
		option -= 1
	elif down:
		option += 1
	
	if option < 0:
		option = 2
	elif option > 2:
		option = 0
	
	pass

# Escolhe a opcao do menu
func pick_option():
	if Input.is_action_just_pressed("ui_accept"):
		match option:
			0: returnGame()
			1: stats()
			2: quitMainMenu()
	pass

# Retorna ao game
func returnGame():
	get_tree().paused = false
	queue_free()
	pass

# Mostra os status do personagem
func stats():
	print("Not yet implemented")
	pass

# Volta para o menu inicial
func quitMainMenu():
	get_tree().paused = false
	get_tree().change_scene(mainMenu)
	queue_free()
	pass