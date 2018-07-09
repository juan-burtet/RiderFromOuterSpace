extends Node

const firstLevel = "res://Scenes/Prelude/Prelude.tscn"

var menu = 0
var scaling = 5

func _ready():
	menu = 0
	scaling = 5
	all_sprites_on_not()
	$MenuSounds/Music.play()
	set_process(true)
	pass

func _input(event):
	if event.is_action_pressed("ui_esc"):
		pass
	pass


func _process(delta):
	
	# Move a opção no Menu
	move_menu()
	
	# Liga a opção selecionada
	option_selected()
	
	# Opção pressionada
	option_pressed()
	
	# movimenta os planetas ao fundo
	animate_background()
	
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
		$MenuSounds/ChangeOption.play()
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
		match menu:
			0: get_tree().change_scene(firstLevel)
			1: $Animation.play("load")
			2: $Animation.play("chapter")
			3: $Animation.play("options")
			4: get_tree().quit()
	pass


# Função que anima o plano de fundo
func animate_background():
	var PlanetsBack = $Parallax/PlanetsBack/Sprite
	var PlanetFront = $Parallax/PlanetFront/Sprite
	var PlanetRing  = $Parallax/PlanetRing/Sprite
	
	movement_planets_left(PlanetsBack, 0.5)
	movement_planets_right(PlanetFront, 1.5)
	change_planet_size(PlanetRing)
	
	pass

# Função que move os planetas para direita
func movement_planets_right(sprite, vel):
	var pos = sprite.get_global_position()
	
	pos.x += vel
	
	if pos.x > 786: 
		pos.x = -30
	
	sprite.set_global_position(pos)
	
	pass

# Função que move os planetas para esquerda
func movement_planets_left(sprite, vel):
	var pos = sprite.get_global_position()
	
	pos.x -= vel
	
	if pos.x < -300: 
		pos.x = 986
	
	sprite.set_global_position(pos)
	
	pass

# Função que modifica o tamanho do planeta
func change_planet_size(sprite):
	var scale = sprite.get_scale()
	
	scale.x += 0.001 * scaling
	scale.y += 0.001 * scaling
	
	sprite.set_scale(scale)
	
	if scale.x > 3:
		scaling = -3
	elif scale.x < 2:
		scaling = 5
	
	pass

# Função que é ativada quando a musica acabou
func _on_Music_finished():
	$MenuSounds/Music.play()
