# PlayerTest.gd
extends KinematicBody2D

# cenas das fases
const firstLevel = "res://Scenes/Maps/Map 1/Section 1/Map 1 Section 1.tscn"
const SecondLevel = "res://Scenes/Maps/Map 1/Section 2/Map 1 Section 2.tscn"
const mainMenu = "res://Scenes/Menus/MainMenu.tscn"
const PAUSE_SCENE = preload("res://Scenes/Player/Pause/Pause.tscn")

# Cenas das armas
const PISTOL_SCENE = preload("res://Tests/Map Test/Pistol.tscn")
const SHOTGUN_SCENE = preload("res://Scenes/Player/Weapons/Shotgun.tscn")
const MACHINEGUN_SCENE = preload("res://Scenes/Player/Weapons/MachineGun.tscn")

# Constante de auxilio no gameplay
const UP = Vector2(0,-1) # Indica a direção pra cima
const GRAVITY = 20 # Gravidade
const MAX_SPEED = 300 # Velocidade Máxima
const JUMP_HEIGHT = -500 # Altura do pulo
const ACCELERATION = 50 # Aceleração
const DASH_SPEED = 1000 # Dash
const PISTOL_TIME = 0.3 # Tempo da Pistola
const SHOTGUN_TIME = 1.0 # Tempo da Shotgun
const MACHINEGUN_TIME = 0.1 # Tempo da Metralhadora

# Variaveis utilizadas no gameplay
var motion = Vector2() # Movimento
var doubleJump = false # Pode dar pulo duplo
var direction = Vector2(1,0) # Direção do tiro
var gun_mode # Escolha da arma
var direcao_padrao = 1 # Direção padrao da arma
var hp = 6 # vida do personagem
var friction = false # Indica que tu parou de se movimentar

# Timers 
onready var pistol_timer = get_node("Timers/pistol_timer")
onready var shotgun_timer = get_node("Timers/shotgun_timer")
onready var machinegun_timer = get_node("Timers/machinegun_timer")

# Função ativada quando o nó é iniciado
func _ready():
	set_process(true)
	pistol_timer.set_one_shot(false)
	shotgun_timer.set_one_shot(false)
	machinegun_timer.set_one_shot(false)
	gun_mode = 1
	pass
	# END _ready

# Função que roda a cada frame
func _physics_process(delta):
	# verifica se o personagem morreu
	check_life()
	
	# atualiza informacoes do jogador
	update_player()
	
	# Confere se o pause foi selecionado
	pause_menu()
	
	# Confere se alguma direção de tiro foi pega
	get_shot_direction()
	
	# mover o personagem
	move_player()

	# Controla os comandos do pulo
	jump_control()

	# movimenta o personagem
	motion = move_and_slide(motion, UP)
	
	# Escolha da arma
	choose_weapon()
	
	# Faz a ação de tiro se o botão foi pressionado
	check_shoot()
	
	# Atualiza as sprites
	atualiza_sprites()
	
	pass
	# END physics_process

# verifica se o personagem morreu
func check_life():
	if !hp:
		if get_parent().get_name() == "Map 1 Section 1":
			get_tree().change_scene(firstLevel)
		else:
			get_tree().change_scene(SecondLevel)
	pass

# Funcao que atualiza algumas opcoes do player
func update_player():
	# Eixo Y é atualizado com a gravidade
	motion.y += GRAVITY
	# Para ficar sempre parado no eixo x
	direction.y = 0
	direction.x = direcao_padrao
	pass

func pause_menu():
	if Input.is_action_just_pressed("ui_esc"):
		get_tree().paused = true
		get_parent().add_child(PAUSE_SCENE.instance())
	pass

# Funcao que move o personagem 
func move_player():
	# Se a tecla esquerda foi pressionada, movimenta pra esquerda
	if Input.is_action_pressed("ui_left"):
		# Movimenta o personagem pra esquerda
		move_left()
		
		# Só faz o dash se o lock não tiver habilitado
		#if !Input.is_action_pressed("ui_lock"):
		if Input.is_action_just_pressed("ui_dash"):
			if $GUI.is_complete():
				dash(-DASH_SPEED)
				$GUI.usou_dash()
	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"):
		# Só faz o dash se o lock não tiver habilitado
		#if !Input.is_action_pressed("ui_lock"):
			
		# Movimenta o personagem pra direita
		move_right()
			
		if Input.is_action_just_pressed("ui_dash"):
			if $GUI.is_complete():
				dash(DASH_SPEED)
				$GUI.usou_dash()

	# Se nenhuma tecla foi digitada, o personagem fica parado
	else:
		# Indica que o personagem parou de se movimentar
		friction = true
		# Toca a Sprite parado
		$Sprite.play("Idle")
	pass

# Funcao para atualizar as sprites do personagem
func atualiza_sprites():
	var x = direction.x
	var y = direction.y
	
	# cima
	if x == 0 and y == -1:
		$Top.play("Cima")
		#$Top.set_offset(Vector2(0,0))
	# Frente
	elif (x == 1 or x == -1) and y == 0:
		$Top.play("Frente")
		#$Top.set_offset(Vector2(2,6))
	# FrenteCima
	elif (x == 1 or x == -1) and y == -1:
		$Top.play("FrenteCima")
		#$Top.set_offset(Vector2(2,3))
	
	
	pass

# Função que escolhe a arma
func choose_weapon():
	if Input.is_action_just_pressed("ui_1"):
		$GUI.get_node("Weapon").play("Pistol")
		gun_mode = 1
	elif Input.is_action_just_pressed("ui_2"):
		$GUI.get_node("Weapon").play("Shotgun")
		gun_mode = 2
	elif Input.is_action_just_pressed("ui_3"):
		$GUI.get_node("Weapon").play("MachineGun")
		gun_mode = 3
	pass
	# END choose_weapon

# Função que checa se o botão de atirar foi apertado
func check_shoot():
	# Se apertou pra atirar, atire
	if Input.is_action_pressed("ui_fire"):
		if gun_mode == 1: # Pistola
			shot_gun(pistol_timer, PISTOL_SCENE, PISTOL_TIME, direction)
		elif gun_mode == 2: # Shotgun
			shot_gun(shotgun_timer, SHOTGUN_SCENE, SHOTGUN_TIME, direction)
		else: # Machinegun
			shot_gun(machinegun_timer, MACHINEGUN_SCENE, MACHINEGUN_TIME, direction)
	pass
	# END check_shoot

# Função para atirar com a arma
func shot_gun(timer, gun_scene, gun_time, direction):
	if !timer.is_one_shot():
		var gun = gun_scene.instance()
		gun.init(direction)
		get_parent().add_child(gun)
		gun.set_position($Gun.get_global_position() + direction*10)
		restart_timer(timer, gun_time)
	pass
	# END shot_gun

# Função que seta o timer da arma
func restart_timer(timer, s):
	timer.set_wait_time(s)
	timer.set_one_shot(true)
	timer.start()
	pass
	# END restart_timer

# Função que movimenta o personagem pra esquerda
func move_left():
	# Aumenta a aceleração
	# Se ultrapassar a velocidade MAXIMA, fica em MAX
	motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
	# Inverte a Sprite pois está indo pra esquerda
	$Sprite.flip_h = true
	$Top.flip_h = true
	# Toca a Sprite de Movimento
	$Sprite.play("Walking")
	# Atualiza a direção
	direction.x = -1
	pass
	# END move_left

# Função que movimenta o personagem pra direita
func move_right():
	# Aumenta a aceleração
	# Se ultrapassar a velocidade MAXIMA, fica em MAX
	motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	# Não inverte a sprite
	$Sprite.flip_h = false
	$Top.flip_h = false
	# Toca a Sprite de Movimento
	$Sprite.play("Walking")
	# Muda a direção
	direction.x = 1
	pass
	# END move_right

# Função que faz o controle do pulo
func jump_control():
	# Se o personagem estiver no chão
	if is_on_floor():
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_select") and is_on_floor():
			# Aumenta o tamanho do pulo
			motion.y = JUMP_HEIGHT
			# É possivel dar um double Jump
			doubleJump = true
		
		# Se o Personagem parou de se movimentar
		if friction:
			# Inicializa o processo de parada
			# Indica que a velocidade inicial vai para 0, 20% de cada vez
			motion.x = lerp(motion.x, 0, 0.2)
	
	# Se o personagem não estiver no chão
	else:
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_select"): # Space
			# Se o double jump estiver em True, ele pula
			if doubleJump:
				# Aumenta o tamanho do pulo
				motion.y = JUMP_HEIGHT
				# DoubleJump retorna pra falso
				doubleJump = false
		
		# Se o Personagem estiver subindo
		if motion.y < 0:
			# Toca a Sprite do Pulo
			$Sprite.play("Jump")
		
		# Se o Personagem estiver caindo
		else:
			# Toca a Sprite de Queda
			$Sprite.play("Fall")

		# Se o Personagem parou de se movimentar
		if friction:
			# Inicializa o processo de parada
			# Indica que a velocidade inicial vai para 0, 5% de cada vez
			motion.x = lerp(motion.x, 0, 0.05)
	pass
	# END jump_control

# Função que faz o movimento dash
func dash(speed):
	motion.x += speed
	move_and_slide(motion, UP) 
	# END dash

func get_shot_direction():
	var cima = Input.is_action_pressed("ui_up") 
	var esquerda = Input.is_action_pressed("ui_left")
	var direita = Input.is_action_pressed("ui_right")
	var baixo = Input.is_action_pressed("ui_down")
	
	if cima and esquerda:
		direction.x = -1
		direction.y = -1
		direcao_padrao = -1
	elif cima and direita:
		direction.x = +1
		direction.y = -1
		direcao_padrao = +1
	#elif baixo and esquerda:
	#	direction.x = -1
	#	direction.y = +1
	#	direcao_padrao = -1
	#elif baixo and direita:
	#	direction.x = +1
	#	direction.y = +1
	#	direcao_padrao = 1
	elif cima:
		direction.x = 0
		direction.y = -1
	#elif baixo:
	#	direction.x = 0
	#	direction.y = +1
	elif esquerda:
		direction.x = -1
		direction.y = 0
		direcao_padrao = -1
	elif direita:
		direction.x = +1
		direction.y = 0
		direcao_padrao = 1
	
	pass

# Função feita pro personagem tomar dano
func receive_damage():
	hp -= 1
	hp = max(0,hp)
	
	if hp == 5:
		$GUI.get_node("Hearts/3").play("Half")
	elif hp == 4:
		$GUI.get_node("Hearts/3").play("Empty")
	elif hp == 3:
		$GUI.get_node("Hearts/2").play("Half")
	elif hp == 2:
		$GUI.get_node("Hearts/2").play("Empty")
	elif hp == 1:
		$GUI.get_node("Hearts/1").play("Half")
	elif hp == 0:
		$GUI.get_node("Hearts/1").play("Empty")
	
	pass

# Signal que indica quando acabou o tempo (pistola)
func _on_pistol_timer_timeout():
	pistol_timer.set_one_shot(false)
	pass 

# Signal que indica quando acabou o tempo (shotgun)
func _on_shotgun_timer_timeout():
	shotgun_timer.set_one_shot(false)
	pass # replace with function body

# Signal que indica quando acabou o tempo (metralhadora)
func _on_machinegun_timer_timeout():
	machinegun_timer.set_one_shot(false)
	pass # replace with function body
