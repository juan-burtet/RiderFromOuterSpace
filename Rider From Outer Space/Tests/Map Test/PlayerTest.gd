# PlayerTest.gd
extends KinematicBody2D

# cenas das fases
const firstLevel = "res://Scenes/Maps/Map 1/Section 1/Map 1 Section 1.tscn"
const SecondLevel = "res://Scenes/Maps/Map 1/Section 2/Map 1 Section 2.tscn"
const mainMenu = "res://Scenes/Menus/MainMenu.tscn"
const PAUSE_SCENE = preload("res://Scenes/Player/Pause/Pause.tscn")
const DEATH_SCENE = preload("res://Scenes/Player/Death Screen/DeathScreen.tscn")

# Cenas das armas
const PISTOL_SCENE = preload("res://Tests/Map Test/Pistol.tscn")
const SHOTGUN_SCENE = preload("res://Scenes/Player/Weapons/Shotgun.tscn")
const MACHINEGUN_SCENE = preload("res://Scenes/Player/Weapons/MachineGun.tscn")

# Posição para sair as armas
const UP_POSITION = Vector2(0,-50)
const UPRIGHT_POSITION = Vector2(20,-30)
const RIGHT_POSITION = Vector2(30,0)
const DOWNRIGHT_POSITION = Vector2(20,35)
const UPLEFT_POSITION = Vector2(-20,-30)
const LEFT_POSITION = Vector2(-30,0)
const DOWNLEFT_POSITION = Vector2(-20,35)


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
var hp = 6# vida do personagem
var friction = false # Indica que tu parou de se movimentar
var can_move = true
var idle
var dir
var jump
var lock

# Timers 
onready var pistol_timer = get_node("Timers/pistol_timer")
onready var shotgun_timer = get_node("Timers/shotgun_timer")
onready var machinegun_timer = get_node("Timers/machinegun_timer")

# Função ativada quando o nó é iniciado
func _ready():
	set_process(false)
	pistol_timer.set_one_shot(false)
	shotgun_timer.set_one_shot(false)
	hp = global.get_hp() 
	machinegun_timer.set_one_shot(false)
	gun_mode = 1
	pass
	# END _ready

func _input(event):
	if event.is_action_pressed("ui_esc"):
		print("entrou")
		pause_menu()
	pass

# Função que roda a cada frame
func _physics_process(delta):
	idle = false
	jump = false
	lock = false
	
	# Confere se a trava está funcionando
	if Input.is_action_pressed("ui_lock"):
		lock = true
	
	# atualiza informacoes do jogador
	update_player()
	
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
		$Sprite.set_visible(false)
		$Top.set_visible(false)
		get_parent().get_node("music").stop()
		get_tree().paused = true
		get_parent().add_child(DEATH_SCENE.instance())
	pass

# Funcao que atualiza algumas opcoes do player
func update_player():
	# Eixo Y é atualizado com a gravidade
	motion.y += GRAVITY
	# Para ficar sempre parado no eixo x
	direction.y = 0
	direction.x = direcao_padrao
	# friction só é real ao ṕparar de movimentar
	friction = false
	pass

func pause_menu():
	get_tree().paused = true
	add_child(PAUSE_SCENE.instance())
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
			if !lock:
				if $GUI.is_complete():
					dash(-global.get_dash_speed())
					$GUI.usou_dash()

	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"):
		# Só faz o dash se o lock não tiver habilitado
		#if !Input.is_action_pressed("ui_lock"):
		
		# Movimenta o personagem pra direita
		move_right()
		
		if Input.is_action_just_pressed("ui_dash"):
			if !lock:
				if $GUI.is_complete():
					dash(global.get_dash_speed())
					$GUI.usou_dash()

	# Se nenhuma tecla foi digitada, o personagem fica parado
	else:
		# Indica que o personagem parou de se movimentar
		friction = true
		# Toca a Sprite parado
		#$Sprite.play("Idle")
		idle = true
	pass

# Funcao para atualizar as sprites do personagem
func atualiza_sprites():
	var x = direction.x
	var y = direction.y
	
	# cima
	if x == 0 and y == -1:
		dir = "Cima"
		$Top.play("Cima")
		#$Top.set_offset(Vector2(0,0))
	# Frente
	elif (x == 1 or x == -1) and y == 0:
		dir = "Frente"
		$Top.play("Frente")
		#$Top.set_offset(Vector2(2,6))
	# FrenteCima
	elif (x == 1 or x == -1) and y == -1:
		dir = "FrenteCima"
		$Top.play("FrenteCima")
		#$Top.set_offset(Vector2(2,3))
	# FrenteBaixo
	elif (x == 1 or x == -1) and y == 1:
		dir = "BaixoCima"
		pass
	
	update_sprites()
	
	pass

# Adicional para mudar as sprites
func update_sprites():
	#$Run.set_disabled(true)
	#$RunDown.set_disabled(true)
	#$RunUp.set_disabled(true)
	#$Normal.set_disabled(true)
	$Player.set_offset(Vector2(0,0))
	
	# Se não estiver no chão
	if jump:
		match dir:
			"Frente":
				$Player.play("JumpRight")
				pass
			"Cima":
				$Player.play("JumpUp")
				pass
			"FrenteCima":
				$Player.play("JumpUpRight")
				pass
			"BaixoCima":
				$Player.play("JumpDownRight")
				pass
	# Esta no chão
	else:
		# Parado
		if idle:
			match dir:
				"Frente":
					$Player.play("IdleRight")
					pass
				"Cima":
					$Player.play("IdleUp")
					pass
				"FrenteCima":
					$Player.play("IdleUpRight")
					pass
				"BaixoCima":
					$Player.play("IdleDownRight")
					pass
			pass
		# Movimentando
		else:
			$Player.set_offset(Vector2(0,8))
			match dir:
				"Frente":
					$Player.play("RunRight")
					pass
				"FrenteCima":
					$Player.play("RunUpRight")
					$Player.set_offset(Vector2(0,5))
					pass
				"BaixoCima":
					$Player.play("RunDownRight")
					pass
			pass
		pass
	
	pass

# Função que escolhe a arma
func choose_weapon():
	if Input.is_action_just_pressed("ui_1"):
		$GUI.get_node("Weapon").play("Pistol")
		$GUI.get_node("WeaponLabel").set_text(" PISTOL")
		gun_mode = 1
	elif Input.is_action_just_pressed("ui_2"):
		$GUI.get_node("Weapon").play("Shotgun")
		$GUI.get_node("WeaponLabel").set_text(" SHOTGUN")
		gun_mode = 2
	elif Input.is_action_just_pressed("ui_3"):
		$GUI.get_node("Weapon").play("MachineGun")
		$GUI.get_node("WeaponLabel").set_text(" MACHINE GUN")
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
		get_parent().add_child(gun)
		gun.init(direction)
		$Gun.set_position(get_gun_position(direction))
		gun.set_position($Gun.get_global_position())
		restart_timer(timer, gun_time)
	pass
	# END shot_gun

func get_gun_position(value):
	var x = value.x
	var y = value.y
	
	# Cima
	if x == 0 and y == -1:
		return UP_POSITION
	# Cima + Direita
	elif x == 1 and y == -1:
		return UPRIGHT_POSITION
	# Cima + Esquerda
	elif x == -1 and y == -1:
		return UPLEFT_POSITION
	# Direita
	elif x == 1 and y == 0:
		return RIGHT_POSITION
	# Esquerda
	elif x == -1 and y == 0:
		return LEFT_POSITION
	# Baixo + Direita
	elif x == 1 and y == 1:
		return DOWNRIGHT_POSITION
	# Baixo + Esquerda
	elif x == -1 and y == 1:
		return DOWNLEFT_POSITION	 

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
	if !lock:
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
	else:
		if is_on_floor():
			motion.x = 0
		idle = true
	# Inverte a Sprite pois está indo pra esquerda
	$Sprite.flip_h = true
	$Top.flip_h = true
	$Player.flip_h = true
	# Toca a Sprite de Movimento
	#$Sprite.play("Walking")
	# Atualiza a direção
	direction.x = -1
	pass
	# END move_left

# Função que movimenta o personagem pra direita
func move_right():
	# Aumenta a aceleração
	# Se ultrapassar a velocidade MAXIMA, fica em MAX
	if !lock:
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
	else:
		if is_on_floor():
			motion.x = 0
		idle = true
	# Não inverte a sprite
	$Sprite.flip_h = false
	$Top.flip_h = false
	$Player.flip_h = false
	# Toca a Sprite de Movimento
	#$Sprite.play("Walking")
	# Muda a direção
	direction.x = 1
	pass
	# END move_right

# Função que faz o controle do pulo
func jump_control():
	# Se o personagem estiver no chão
	if is_on_floor():
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_jump") and is_on_floor():
			# Aumenta o tamanho do pulo
			motion.y = global.get_jump_height()
			# É possivel dar um double Jump
			doubleJump = true
			jump = true
		
		# Se o Personagem parou de se movimentar
		if friction:
			# Inicializa o processo de parada
			# Indica que a velocidade inicial vai para 0, 20% de cada vez
			motion.x = lerp(motion.x, 0, 0.2)
	
	# Se o personagem não estiver no chão
	else:
		jump = true
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_jump"): # Space
			# Se o double jump estiver em True, ele pula
			if doubleJump:
				# Aumenta o tamanho do pulo
				motion.y = global.get_jump_height()
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
	elif baixo and esquerda:
		direction.x = -1
		direction.y = +1
		direcao_padrao = -1
	elif baixo and direita:
		direction.x = +1
		direction.y = +1
		direcao_padrao = 1
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
	$Animation.play("hit")
	hp -= 1
	hp = max(0,hp)
	
	update_hp()
	check_life()
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

# indica se tu pode se movimentar
func set_can_move(value):
	can_move = value

# retorna o valor de can_move
func get_can_move():
	return can_move

func on_aumentou_hp():
	hp = global.get_hp()
	update_hp()
	pass

func update_hp():
	match hp:
		0:
			$GUI.get_node("Hearts/1").play("Empty")
			$GUI.get_node("Hearts/2").play("Empty")
			$GUI.get_node("Hearts/3").play("Empty")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		1:
			$GUI.get_node("Hearts/1").play("Half")
			$GUI.get_node("Hearts/2").play("Empty")
			$GUI.get_node("Hearts/3").play("Empty")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		2:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Empty")
			$GUI.get_node("Hearts/3").play("Empty")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		3:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Half")
			$GUI.get_node("Hearts/3").play("Empty")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		4:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Empty")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		5:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Half")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		6:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Empty")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		7:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Half")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		8:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Full")
			$GUI.get_node("Hearts/5").play("Empty")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		9:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Full")
			$GUI.get_node("Hearts/5").play("Half")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		10:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Full")
			$GUI.get_node("Hearts/5").play("Full")
			$GUI.get_node("Hearts/6").play("Empty")
			pass
		11:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Full")
			$GUI.get_node("Hearts/5").play("Full")
			$GUI.get_node("Hearts/6").play("Half")
			pass
		12:
			$GUI.get_node("Hearts/1").play("Full")
			$GUI.get_node("Hearts/2").play("Full")
			$GUI.get_node("Hearts/3").play("Full")
			$GUI.get_node("Hearts/4").play("Full")
			$GUI.get_node("Hearts/5").play("Full")
			$GUI.get_node("Hearts/6").play("Full")
			pass
	pass

func get_attack(string):
	receive_damage()
	var x = 0
	var y = 0
	match string:
		"left":
			x = -2000
		"right":
			x = 2000
		"up":
			y = -500
			pass
	
	motion.x = 0
	motion = move_and_slide(motion,UP)
	motion.x = x
	motion.y = y
	motion = move_and_slide(motion,UP)
	
	pass