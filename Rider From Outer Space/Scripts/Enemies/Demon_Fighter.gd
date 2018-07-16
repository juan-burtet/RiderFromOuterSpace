# Demon_Fighter.gd
extends KinematicBody2D

# Constantes
const UP = Vector2(0,-1)
const SPEED = 100
const GRAVITY = 20
const MAX_HP = 200
const RIGHT_OFFSET = Vector2(20,-10)
const LEFT_OFFSET = Vector2(-10,-10)

# Movimento
var motion = Vector2()
var hp 
onready var timer = $Timer

signal ataque

func _ready():
	timer.set_one_shot(false)
	hp = MAX_HP
	$HP.set_min(0)
	$HP.set_max(MAX_HP)
	print_hp()
	$Sprite.play("Idle")
	$Sprite.set_offset(Vector2(0,0))

func _process(delta):
	
	motion.y += GRAVITY
	
	if $Left.is_colliding() or $LeftUp.is_colliding():
		var move = false
		var left = $Left.get_collider()
		var leftUp = $LeftUp.get_collider()
		
		if left != null:
			if left.get_name() == "PlayerTest":
				move = true
		if leftUp != null:
			if leftUp.get_name() == "PlayerTest":
				move = true
		
		if move:
			motion.x = -SPEED
			$Sprite.flip_h = false
			$Sprite.play("Run")
	elif $Right.is_colliding() or $RightUp.is_colliding():
		var move = false
		var right = $Right.get_collider()
		var rightUp = $RightUp.get_collider()
		
		if right != null:
			if right.get_name() == "PlayerTest":
				move = true
		if rightUp != null:
			if rightUp.get_name() == "PlayerTest":
				move = true
		
		if move:
			motion.x = SPEED
			$Sprite.flip_h = true
			$Sprite.play("Run")
	else:
		$Sprite.play("Idle")
	
	if !timer.is_one_shot():
		if $LeftAttack.is_colliding():
			$Sprite.play("Attack")
			$Sprite.set_offset(LEFT_OFFSET)
			do_attack("left")
			set_process(false)
			pass
		elif $RightAttack.is_colliding():
			$Sprite.play("Attack")
			$Sprite.set_offset(RIGHT_OFFSET)
			do_attack("right")
			set_process(false)
			pass
	
	motion = move_and_slide(motion, UP)
	pass


func do_attack(string):
	var player
	
	match string:
		"left":
			player = $LeftAttack.get_collider()
			if player != null:
				if player.get_name() == "PlayerTest":
					$Sprite.flip_h = false
					yield($Sprite, "attack")
					$Sounds/attack.play()
					player = $LeftAttack.get_collider()
					if player != null:
						if player.get_name() == "PlayerTest":
							player.get_attack("left")
							
			pass
		"right":
			player = $RightAttack.get_collider()
			if player != null:
				if player.get_name() == "PlayerTest":
					$Sprite.flip_h = true
					yield($Sprite, "attack")
					$Sounds/attack.play()
					player = $RightAttack.get_collider()
					if player != null:
						if player.get_name() == "PlayerTest":
							player.get_attack("right")
			pass
	
	yield($Sprite, "over")
	restart_timer()
	$Sprite.set_offset(Vector2(0,0))
	set_process(true)
	pass

func print_hp():
	$HP.set_value(hp)

func dies():
	set_process(false)
	$Collision.set_disabled(true)
	$HP.set_visible(false)
	$anim.play("death")
	$Sounds/death.play()
	yield($anim, "animation_finished")
	yield($Sounds/death,"finished")
	queue_free()

func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	print_hp()
	if !hp:
		dies()
	else:
		$anim.play("hit")
	pass

func restart_timer():
	timer.set_one_shot(true)
	timer.set_wait_time(3.0)
	timer.start()
	pass

func _on_Timer_timeout():
	timer.set_one_shot(false)

func _on_topLeft_body_entered(body):
	body.get_attack("left")
	pass # replace with function body


func _on_topRight_body_entered(body):
	body.get_attack("right")
	pass # replace with function body
