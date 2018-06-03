extends KinematicBody2D

const UP = Vector2(0,-1)
const SPEED = 200
const GRAVITY = 20

var motion = Vector2(SPEED, 0)

func _process(delta):
	motion.y += GRAVITY
	
	if $left.is_colliding() or !$leftDown.is_colliding():
		motion.x = SPEED
	elif $right.is_colliding() or !$rightDown.is_colliding():
		motion.x = -SPEED
	
	motion = move_and_slide(motion, UP)
	pass
