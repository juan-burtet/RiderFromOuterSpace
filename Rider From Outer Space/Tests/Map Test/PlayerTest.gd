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

# Variaveis utilizadas no gameplay
var motion = Vector2() # Movimento
var doubleJump = false # Pode dar pulo duplo
var direction = Vector2(1,0) # Direção do tiro

# Timers 
onready var timer = get_node("Timer") # Nó Timer


# Função ativada quando o nó é iniciado
func _ready():
	set_process(true)
	timer.set_one_shot(false)

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
	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"):
		# Movimenta o personagem pra direita
		move_right()
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
	
	if Input.is_action_just_pressed("ui_fire"):
		if !timer.is_one_shot():
			shot_pistol(direction)
			restart_timer()

func shot_pistol(direction):
	var pistol = PISTOL_SCENE.instance()
	pistol.init(direction)
	get_parent().add_child(pistol)
	pistol.set_position($Gun.get_global_position())
	

func restart_timer():
	timer.set_wait_time(.5)
	timer.set_one_shot(true)
	timer.start()

func _on_Timer_timeout():
	timer.set_one_shot(false)
	pass # replace with function body

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

# Função que faz o controle do pulo
func jump_control(friction):
	# Se o personagem estiver no chão
	if is_on_floor():
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_select"):
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