# Blob_Bomber.gd
extends KinematicBody2D

# Constantes
const UP = Vector2(0,-1)
const SPEED = 100
const GRAVITY = 20
const MAXHP = 1
const FLOATING = -20

# Movimento
var motion = Vector2()
var hp

func _ready():
	$Body.play("Idle")
	$HP.set_max(MAXHP)
	hp = MAXHP
	print_hp()
	#floating_body()
	pass

func _process(delta):
	if $RayCast/Down.is_colliding():
		motion.y = -10
		pass
	else:
		motion.y += GRAVITY 
	
	if $RayCast/Left.is_colliding() or $RayCast/LeftUp.is_colliding():
		motion.x = -SPEED
		print("esquerda")
		pass
	elif $RayCast/Right.is_colliding() or $RayCast/RightUp.is_colliding():
		motion.x = SPEED
		print("direita")
	
	
	if motion.x > 0:
		$Body.play("Run")
		$Body.flip_h = true
		pass
	elif motion.x < 0:
		$Body.play("Run")
		$Body.flip_h = false
		pass
	else:
		$Body.play("Idle")
	
	
	motion = move_and_slide(motion, UP)
	#floating_body()
	pass

func print_hp():
	$HP.set_value(hp)

func floating_body():
	var pos = get_global_position()
	pos.y += FLOATING
	set_global_position(pos)
	pass

func dies():
	$HP.set_visible(false)
	$Body.set_visible(false)
	$Explosion.set_visible(true)
	$Explosion.play("die")
	$Sounds/explode.play()
	yield($Explosion, "animation_finished")
	yield($Sounds/explode,"finished")
	queue_free()

func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	print_hp()
	if !hp:
		set_process(false)
		dies()
	pass

func _on_AreaExplode_body_entered(body):
	set_process(false)
	body.receive_damage()
	$AreaExplode.queue_free()
	dies()
