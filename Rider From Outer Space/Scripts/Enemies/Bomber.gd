# Bomber.gd
extends KinematicBody2D

# Constantes
const UP = Vector2(0,-1)
const SPEED = 100
const GRAVITY = 20

# Movimento
var motion = Vector2()
var maxHp = 1
var hp = 1

signal morre
onready var timer = get_node("Timer")

func _ready():
	timer.set_one_shot(false)

func _process(delta):
	motion.y += GRAVITY
	
	print_hp()
	
	if $left.is_colliding() or $LeftTop.is_colliding():
		motion.x = -SPEED
	elif $right.is_colliding() or $rightTop.is_colliding():
		motion.x = SPEED
	
	if motion.x > 0:
		$Sprite.flip_h = false
		$Sprite.play("Walk")
	elif motion.x < 0:
		$Sprite.flip_h = true
		$Sprite.play("Walk")
	else:
		$Sprite.play("Idle")
	
	motion = move_and_slide(motion, UP)
	pass

func print_hp():
	$HP.set_value(hp)

func start_timer():
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.start()
	pass

func dies():
	$Sprite.set_visible(false)
	$Explosion.play("death")
	yield($Explosion, "animation_finished")
	queue_free()

func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	if !hp:
		dies()
	pass

# Entrou na Area do inimigo
func _on_AreaExplode_body_entered(body):
	if !body.get_collision_layer_bit(1): 
		body.receive_damage()
		$AreaExplode.queue_free()
		dies()
	pass # replace with function body



func _on_Timer_timeout():
	timer.set_one_shot(false)
	#emit_signal(morre)
	pass # replace with function body


func _on_Sprite_frame_changed():
	pass # replace with function body
