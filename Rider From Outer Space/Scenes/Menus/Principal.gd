extends Node

const firstLevel = "res://Scenes/Prelude/Prelude.tscn"

var menu = 0
var scaling = 5
signal sound

func on_menu():
	$GameLogo.set_visible(true)
	$MenuOptions/StartGame.set_visible(true)
	$MenuOptions/LoadGame.set_visible(true)
	$MenuOptions/ChapterSelect.set_visible(true)
	$MenuOptions/Options.set_visible(true)
	$MenuOptions/QuitGame.set_visible(true)
	set_process(true)
	pass

func off_menu():
	$GameLogo.set_visible(false)
	$MenuOptions/StartGame.set_visible(false)
	$MenuOptions/LoadGame.set_visible(false)
	$MenuOptions/ChapterSelect.set_visible(false)
	$MenuOptions/Options.set_visible(false)
	$MenuOptions/QuitGame.set_visible(false)
	set_process(false)
	pass

func _ready():
	menu = 0
	all_sprites_on_not()
	var parent = get_parent()
	connect("sound", parent, "on_sound")
	pass

func _process(delta):
	
	# Move a opção no Menu
	move_menu()
	
	# Liga a opção selecionada
	option_selected()
	
	# Opção pressionada
	option_pressed()
	
	pass

# Função que deixa todas as sprites desligadas
func all_sprites_on_not():
	$MenuOptions/StartGame.play("not")
	$MenuOptions/LoadGame.play("not")
	$MenuOptions/ChapterSelect.play("not")
	$MenuOptions/Options.play("not")
	$MenuOptions/QuitGame.play("not")
	pass

# Função que move a opção escolhida no menu
func move_menu():
	var sound = false
	if Input.is_action_just_pressed("ui_upMenu"):
		sound = true
		menu -= 1
		if menu < 0: menu = 4
		all_sprites_on_not()
	elif Input.is_action_just_pressed("ui_downMenu"):
		sound = true
		menu += 1
		if menu > 4: menu = 0
		all_sprites_on_not()
	
	if sound:
		emit_signal("sound")
	pass

# Função que liga a Sprite da opção selecionada
func option_selected():
	match menu:
		0: $MenuOptions/StartGame.play("selected")
		1: $MenuOptions/LoadGame.play("selected")
		2: $MenuOptions/ChapterSelect.play("selected")
		3: $MenuOptions/Options.play("selected")
		4: $MenuOptions/QuitGame.play("selected")
	pass

# Função para pressionar uma opção
func option_pressed():
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("sound")
		match menu:
			0: 
				get_tree().change_scene(firstLevel)
				global.set_map1()
				global.set_loadgame(firstLevel)
			1: 
				var level = global.get_loadgame()
				if level != null:
					get_tree().change_scene(level)
				else:
					$anim.play("not")
			2: 
				get_parent().get_node("ChapterSelect").on_menu()
				off_menu()
			3: 
				get_parent().get_node("Options").on_menu()
				off_menu()
			4: 
				get_tree().quit()
	pass
