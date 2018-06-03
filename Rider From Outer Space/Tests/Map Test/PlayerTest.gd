# PlayerTest.gd
extends KinematicBody2D

# Cenas das armas
const PISTOL_SCENE = preload("res://Tests/Map Test/Pistol.tscn") # Pistola
const MACHINEGUN_SCENE = preload("res://Tests/Map Test/MachineGun.tscn") # Metralhadora

# Constante de auxilio no gameplay
const UP = Vector2(0,-1) # Indica a direção pra cima
const GRAVITY = 20 # Gravidade
const MAX_SPEED = 300 # Velocidade Máxima
const JUMP_HEIGHT = -500 # Altura do pulo
const ACCELERATION = 50 # Aceleração
const DASH_SPEED = 1000 # Dash

# Variaveis utilizadas no gameplay
var motion = Vector2() # Movimento
var doubleJump = false # Pode dar pulo duplo
var direction = Vector2(1,0) # Direção do tiro

# Timers 
onready var timer = get_node("gun_timer") # timer da arma

# Função ativada quando o nó é iniciado
func _ready():
	set_process(true)
	timer.set_one_shot(false)
	pass
	# END _ready

# Função que roda a cada frame
func _physics_process(delta):
	# Eixo Y é atualizado com a gravidade
	motion.y += GRAVITY
	# Indica que tu parou de se movimentar
	var friction = false
	
	# Se a tecla esquerda foi pressionada, movimenta pra esquerda
	if Input.is_action_pressed("ui_left"):
		# Movimenta o personagem pra esquerda
		move_left()
		
		if Input.is_action_just_pressed("ui_dash"):
				dash(-DASH_SPEED)
	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"):
		# Movimenta o personagem pra direita
		move_right()
		
		if Input.is_action_just_pressed("ui_dash"):
				dash(DASH_SPEED)

	# Se nenhuma tecla foi digitada, o personagem fica parado
	else:
		# Indica que o personagem parou de se movimentar
		friction = true
		# Toca a Sprite parado
		$Sprite.play("Idle")

	# Controla os comandos do pulo
	jump_control(friction)

	# Movimenta o personagem
	motion = move_and_slide(motion, UP)
	
	# Se apertou pra atirar, atire
	if Input.is_action_just_pressed("ui_fire"):
		shot_pistol(direction)
	pass
	# END physics_process

# Função que atira uma pistola
func shot_pistol(direction):
	if !timer.is_one_shot():
		var pistol = PISTOL_SCENE.instance()
		pistol.init(direction)
		get_parent().add_child(pistol)
		pistol.set_position($Gun.get_global_position() + direction*10)
		restart_timer()
	pass
	# END shot_pistol

# Função que seta o timer da arma
func restart_timer():
	timer.set_wait_time(0.1)
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
	# Toca a Sprite de Movimento
	$Sprite.play("Walking")
	# Muda a direção
	direction.x = 1
	pass
	# END move_right

# Função que faz o controle do pulo
func jump_control(friction):
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
				print("double jump!")
		
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

# Signal pra saber se o timer da arma acabou
func _on_gun_timer_timeout():
	timer.set_one_shot(false)
	pass 
	# END _on_gun_timer_timeout