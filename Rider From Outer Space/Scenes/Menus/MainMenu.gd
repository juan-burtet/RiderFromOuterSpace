extends Node

const firstLevel = "res://Scenes/Maps/Map 1/Section 1/Map 1 Section 1.tscn"

var menu
var scaling 

func _ready():
	menu = 0
	scaling = 5
	all_sprites_on_not()
	pass


func _process(delta):
	
	# Desliga todas as sprites
	#all_sprites_on_not()
	
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
	if Input.is_action_just_pressed("ui_upMenu"):
		menu -= 1
		if menu < 0: menu = 4
		all_sprites_on_not()
	elif Input.is_action_just_pressed("ui_downMenu"):
		menu += 1
		if menu > 4: menu = 0
		all_sprites_on_not()
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
			1: print("Load Game not yet implemented")
			2: print("Chapter Select not yet implemented")
			3: print("Options not yet implemented")
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