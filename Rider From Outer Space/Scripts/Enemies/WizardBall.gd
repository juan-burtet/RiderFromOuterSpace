# WizardBall.gd
extends Area2D

# Tiro para esquerda
const LEFT_OFFSET = Vector2(8,-7)
const LEFT_ROTATION = PI/2

# Tiro para Esquerda + Cima
const LEFT_UP_OFFSET = Vector2(6,-14)
const LEFT_UP_ROTATION = (3*PI)/4

# Tiro para Cima
const UP_OFFSET = Vector2(0,-16)
const UP_ROTATION = PI

# Tiro para Direita + Cima
const RIGHT_UP_OFFSET = Vector2(-5,-14)
const RIGHT_UP_ROTATION = - ((3*PI)/4)

# Tiro para Direita
const RIGHT_OFFSET = Vector2(-8,-8)
const RIGHT_ROTATION = - (PI/2)

# Velocidade da Bala
const SPEED = 300
# Direção da bala
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction
	update_dir(direction)
	set_process(true)

func update_dir(dir):
	match dir:
		# Direita
		Vector2(1,0):
			$Sprite.set_offset(RIGHT_OFFSET)
			$Sprite.set_rotation(RIGHT_ROTATION)
			pass
		# Cima
		Vector2(0,-1):
			$Sprite.set_offset(UP_OFFSET)
			$Sprite.set_rotation(UP_ROTATION)
			pass
		# Esquerda
		Vector2(-1,0):
			$Sprite.set_offset(LEFT_OFFSET)
			$Sprite.set_rotation(LEFT_ROTATION)
			pass
		# Esquerda + Cima
		Vector2(-1,-1):
			$Sprite.set_offset(LEFT_UP_OFFSET)
			$Sprite.set_rotation(LEFT_UP_ROTATION)
			pass
		# Direita + Cima
		Vector2(1,-1):
			$Sprite.set_offset(RIGHT_UP_OFFSET)
			$Sprite.set_rotation(RIGHT_UP_ROTATION)
			pass
	pass

func _process(delta):
	translate(motion * SPEED * delta)
	pass

func _on_Visibility_screen_exited():
	queue_free()

func _on_WizardBall_body_entered(body):
	$Collision.set_disabled(true)
	if body.get_name() == "PlayerTest":
			body.receive_damage()
	$anim.play("destroy")
	yield($anim, "animation_finished")
	queue_free()
