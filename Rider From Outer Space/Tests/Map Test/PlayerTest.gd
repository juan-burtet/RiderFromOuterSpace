extends KinematicBody2D

# Constante para indicar a direção pra cima.
const UP = Vector2(0,-1)
# Constante que indica a aceleração da gravidade
const GRAVITY = 20
# Constante que indica a velocidade do personagem
const MAX_SPEED = 900
# Constante que indica o tamanho do pulo
const JUMP_HEIGHT = -500
# Constante que indica a aceleração
const ACCELERATION = 50
# Variavel que indica a posição na tela do Personagem (x,y)
var motion = Vector2()
# Variavel booleana que indica que pode dar o duplo pulo
var doubleJump = false

func _physics_process(delta):

	# Eixo Y é atualizado com a gravidade
	motion.y += GRAVITY
	# Indica que tu parou de se movimentar
	var friction = false
	
	# Se a tecla esquerda foi pressionada, movimenta pra esquerda
	if Input.is_action_pressed("ui_left"): # Left Arrow

		# Aumenta a aceleração
		# Se ultrapassar a velocidade MAXIMA, fica em MAX
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)

		# Inverte a Sprite pois está indo pra esquerda
		$Sprite.flip_h = true

		# Toca a Sprite de Movimento
		$Sprite.play("Walking")

	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"): # Right Arrow
		# Aumenta a aceleração
		# Se ultrapassar a velocidade MAXIMA, fica em MAX
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)

		# Não inverte a sprite
		$Sprite.flip_h = false

		# Toca a Sprite de Movimento
		$Sprite.play("Walking")

	# Se nenhuma tecla foi digitada, o personagem fica parado
	else:
		# Indica que o personagem parou de se movimentar
		friction = true

		# Toca a Sprite parado
		$Sprite.play("Idle")

	# Se o personagem estiver no chão
	if is_on_floor():

		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_select"): # Space
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

	# Motion recebe o valor atual depois do movimento
	motion = move_and_slide(motion, UP)
