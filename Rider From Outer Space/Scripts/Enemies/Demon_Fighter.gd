# Demon_Fighter.gd
extends KinematicBody2D

# Constantes
const UP = Vector2(0,-1)
const SPEED = 100
const GRAVITY = 20
const MAX_HP = 200
const RIGHT_OFFSET = Vector2(50,0)
const LEFT_OFFSET = Vector2(0,0)

# Movimento
var motion = Vector2()
var hp 
onready var timer = $Timer

signal over


func _ready():
	timer.set_one_shot(false)
	hp = MAX_HP

func _process(delta):
	$attack.set_visible(false)
	$idle.set_visible(true)
	$attack.set_offset(LEFT_OFFSET)
	
	motion.y += GRAVITY
	
	print_hp()
	
	if $Left.is_colliding() or $LeftUp.is_colliding():
		motion.x = -SPEED
	elif $Right.is_colliding() or $RightUp.is_colliding():
		motion.x = SPEED
	
	if motion.x > 0:
		$idle.flip_h = true
		$anim.play("run")
	elif motion.x < 0:
		$idle.flip_h = false
		$anim.play("run")
	else:
		$anim.play("idle")
	
	if !timer.is_one_shot():
		if $LeftAttack.is_colliding():
			do_attack("left")
			yield(self, "over")
			pass
		elif $RightAttack.is_colliding():
			do_attack("right")
			yield(self, "over")
			pass
	
	motion = move_and_slide(motion, UP)
	pass

func do_attack(string):
	var player
	
	anim_attack()
	yield(self,"over")
	match string:
		"left":
			player = $LeftAttack.get_collider()
			if player != null:
				player.get_attack("left")
			pass
		"right":
			player = $RightAttack.get_collider()
			if player != null:
				player.get_attack("right")
			pass
	
	restart_timer()
	pass

func anim_attack():
	$idle.set_visible(false)
	$attack.set_visible(true)
	set_process(false)
	$anim.play("attack")
	yield($anim,"animation_finished")
	emit_signal("over")
	set_process(true)

func print_hp():
	$HP.set_value(hp)

func dies():
	set_process(false)
	$anim.play("death")
	yield($anim, "animation_finished")
	queue_free()

func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	if !hp:
		dies()
	pass

func restart_timer():
	timer.set_one_shot(true)
	timer.set_wait_time(1.0)
	timer.start()
	pass

func _on_Timer_timeout():
	timer.set_one_shot(false)
