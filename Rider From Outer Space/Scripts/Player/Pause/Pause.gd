# Pause.gd
extends CanvasLayer

const mainMenu = "res://Scenes/Menus/MainMenu.tscn"
const UPGRADE_SCENE = preload("res://Scenes/Player/Pause/Upgrades.tscn")

var move
var option
var yellow = Color(1,1,0,1)
var white = Color(1,1,1,1)

onready var timer = $Timer

signal song

func _ready():
	move = true
	option = 0
	var parent = get_parent()
	var grandparent = parent.get_parent()
	connect("song", grandparent, "_on_music_finished")
	pass

func _input(event):
	if event.is_action_pressed("ui_esc") and move:
		print("oi")
		returnGame()

func _process(delta):
	if move:
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
	set_process(false)
	timer.set_one_shot(true)
	timer.set_wait_time(0.1)
	timer.start()
	yield(timer,"timeout")
	get_tree().paused = false
	emit_signal("song")
	queue_free()
	pass

# Mostra os status do personagem
func stats():
	var upgrade = UPGRADE_SCENE.instance()
	add_child(upgrade)
	move = false
	yield(upgrade, "saiu")
	move = true
	pass

# Volta para o menu inicial
func quitMainMenu():
	get_tree().paused = false
	get_tree().change_scene(mainMenu)
	queue_free()
	pass