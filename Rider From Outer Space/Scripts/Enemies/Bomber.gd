# Bomber.gd
extends KinematicBody2D

# Constantes
const UP = Vector2(0,-1)
const SPEED = 400
const GRAVITY = 20

# Movimento
var motion = Vector2()

func _process(delta):
	motion.y += GRAVITY
	
	if $left.is_colliding() or $LeftTop.is_colliding():
		motion.x = -SPEED
	elif $right.is_colliding() or $rightTop.is_colliding():
		motion.y = SPEED
	
	move_and_slide(motion, UP)
	pass


# Entrou na Area do inimigo
func _on_AreaExplode_body_entered(body):
	if !body.get_collision_layer_bit(1): 
		print("explodiu")
		queue_free()
	pass # replace with function body

