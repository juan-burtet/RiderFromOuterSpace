extends KinematicBody2D

# Cenas das armas
const PISTOL_SCENE = preload("res://Tests/Map Test/Pistol.tscn") # Pistola


const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200

var motion = Vector2(0,0)
onready var timer = $Timer

func _ready():
	timer.set_one_shot(false)

func _process(delta):
	motion.y += GRAVITY
	
	if $right.is_colliding():
		teste($right)
	if $left.is_colliding():
		teste($left)
	if $up.is_colliding():
		teste($up)
	if $leftUp.is_colliding():
		teste($leftUp)
	if $rightUp.is_colliding():
		teste($rightUp)
	
	motion = move_and_slide(motion, UP)
	pass

func teste(node):
	if node.get_collider() != null:
		if node.get_collider().get_name() == "PlayerTest":
			if node.get_name() == "left":
				shoot(Vector2(-1,0))
				motion.x = -SPEED
			elif node.get_name() == "right":
				shoot(Vector2(1,0))
				motion.x = SPEED
			elif node.get_name() == "up":
				shoot(Vector2(0,-1))
				motion.x = 0
			elif node.get_name() == "rightUp":
				shoot(Vector2(1,-1))
				motion.x = SPEED
			elif node.get_name() == "leftUp":
				shoot(Vector2(-1,-1))
				motion.x = -SPEED
		
	pass
	
func shoot(direction):
	if !timer.is_one_shot():
		var pistol = PISTOL_SCENE.instance()
		pistol.init(direction)
		get_parent().add_child(pistol)
		pistol.set_position($Gun.get_global_position())
		restart_timer()

func restart_timer():
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	timer.start()

func _on_Timer_timeout():
	timer.set_one_shot(false)
	pass # replace with function body
