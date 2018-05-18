extends KinematicBody2D

# Constante para indicar a direção pra cima.
const UP = Vector2(0,-1)
# Constante que indica a aceleração da gravidade
const GRAVITY = 20
# Constante que indica a velocidade do personagem
const SPEED = 200
# Constante que indica o tamanho do pulo
const JUMP_HEIGHT = -400
# Variavel que indica a posição na tela do Personagem (x,y)
var motion = Vector2()

func _physics_process(delta):
	
	# Eixo Y é atualizado com a gravidade 
	motion.y += GRAVITY
	
	# Se a tecla esquerda foi pressionada, movimenta pra esquerda
	if Input.is_action_pressed("ui_left"): # Left Arrow
		motion.x = -SPEED
		$Sprite.flip_h = true
		$Sprite.play("Walking")
	# Se a teclada direita foi pressionada, movimenta pra direita
	elif Input.is_action_pressed("ui_right"): # Right Arrow
		motion.x = SPEED
		$Sprite.flip_h = false
		$Sprite.play("Walking")
	# Se nenhuma tecla foi digitada, o personagem fica parado
	else:
		motion.x = 0
		$Sprite.play("Idle")
	
	# Se o personagem estiver no chão
	if is_on_floor():
		# Se a tecla espaço foi pressionada, pula
		if Input.is_action_just_pressed("ui_select"): # Space
			motion.y = JUMP_HEIGHT
	else:
		$Sprite.play("Jump")
	
	# Motion recebe o valor atual depois do movimento
	motion = move_and_slide(motion, UP)

