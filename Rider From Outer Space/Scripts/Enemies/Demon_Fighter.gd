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
onready var timer_ataque = $Timer_attack

signal andou
signal parou

func _ready():
	timer.set_one_shot(false)
	hp = MAX_HP
	$HP.set_min(0)
	$HP.set_max(MAX_HP)
	print_hp()
	connect("andou", self, "on_andou")
	

func _process(delta):
	$attack.set_visible(false)
	$idle.set_visible(true)
	$attack.set_offset(LEFT_OFFSET)
	
	motion.y += GRAVITY
	
	if $Left.is_colliding() or $LeftUp.is_colliding():
		if motion.x == 0:
			emit_signal("andou")
		motion.x = -SPEED
	elif $Right.is_colliding() or $RightUp.is_colliding():
		if motion.x == 0:
			emit_signal("andou")
		motion.x = SPEED
	
	if motion.x > 0:
		$idle.flip_h = true
		$attack.flip_h = true
	elif motion.x < 0:
		$idle.flip_h = false
		$attack.flip_h = false
	else:
		$anim.play("idle")
	
	if !timer.is_one_shot():
		if $LeftAttack.is_colliding():
			do_attack("left")
			set_process(false)
			pass
		elif $RightAttack.is_colliding():
			do_attack("right")
			set_process(false)
			pass
	
	motion = move_and_slide(motion, UP)
	pass

func on_andou():
	$anim.play("run")


func do_attack(string):
	var player
	
	match string:
		"left":
			player = $LeftAttack.get_collider()
			if player != null:
				anim_attack()
				timer_ataque.set_wait_time(0.3)
				timer.start()
				yield(timer,"timeout")
				timer.stop()
				player = $LeftAttack.get_collider()
				if player != null:
					player.get_attack("left")
			pass
		"right":
			player = $RightAttack.get_collider()
			if player != null:
				anim_attack()
				timer_ataque.set_wait_time(0.3)
				timer.start()
				yield(timer,"timeout")
				timer.stop()
				player = $RightAttack.get_collider()
				if player != null:
					player.get_attack("right")
			pass
	
	restart_timer()
	$anim.play("idle")
	set_process(true)
	pass

func anim_attack():
	$idle.set_visible(false)
	$attack.set_visible(true)
	$anim.play("attack")

func print_hp():
	$HP.set_value(hp)

func dies():
	$damage.clear_caches()
	$damage.play("death")
	yield($damage, "animation_finished")
	queue_free()

func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	print_hp()
	if !hp:
		set_process(false)
		dies()
	$damage.clear_caches()
	$damage.play("hit")
	yield($damage,"animation_finished")
	pass

func restart_timer():
	timer.set_one_shot(true)
	timer.set_wait_time(3.0)
	timer.start()
	pass

func _on_Timer_timeout():
	timer.set_one_shot(false)
