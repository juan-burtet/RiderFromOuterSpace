extends Node

var scaling
func _ready():
	scaling = 5
	$MenuSounds/Music.play()
	$Principal.on_menu()
	$ChapterSelect.off_menu()
	$Options.off_menu()
	pass


func _process(delta):
	# movimenta os planetas ao fundo
	animate_background()
	
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

func on_sound():
	$MenuSounds/ChangeOption.play()