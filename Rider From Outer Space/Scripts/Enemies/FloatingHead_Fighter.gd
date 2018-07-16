# FloatingHead_Fighter.gd
extends KinematicBody2D

# Velocidade
export var SPEED = 150
# HP
export var MAXHP = 50

const UP = Vector2(0,-1)
const GRAVITY = 20

onready var timer = $Timer
var motion = Vector2(0,0)
var hp
var way

func _ready():
	way = ""
	hp = MAXHP
	$HP.set_max(MAXHP)
	update_hp()
	timer.set_one_shot(false)
	pass

func update_hp():
	$HP.set_value(hp)

func _process(delta):
	motion.y += GRAVITY
	
	if $UpAttack.is_colliding():
		test_attack($UpAttack)
	
	if !timer.is_one_shot():
		if $LeftAttack.is_colliding():
			test_attack($LeftAttack)
		elif $RightAttack.is_colliding():
			test_attack($RightAttack)
		
		if $LeftUp.is_colliding():
			test_move($LeftUp)
		if $Left.is_colliding():
			test_move($Left)
		if $Right.is_colliding():
			test_move($Right)
		if $RightUp.is_colliding():
			test_move($RightUp)
	else:
		match way:
			"left":
				motion.x = -SPEED
				$Sprite.flip_h = true
			"right":
				motion.x = SPEED
				$Sprite.flip_h = false
	
	motion = move_and_slide(motion, UP)
	pass

func test_attack(node):
	if node == null:
		return
	
	var player = node.get_collider()
	
	if player == null:
		return
	
	if player.get_name() != "PlayerTest":
		return
	
	match node.get_name():
		"LeftAttack": 
			player.get_attack("left")
			way = "right"
			restart_timer()
		"RightAttack":
			player.get_attack("right")
			way = "left"
			restart_timer()
		"UpAttack":
			player.get_attack("up")
	
	$Sounds/attack.play()
	
	pass

func test_move(node):
	if node == null:
		return
	
	var player = node.get_collider()
	
	if player == null:
		return
	
	if player.get_name() != "PlayerTest":
		return
	
	match node.get_name():
		"Left": 
			motion.x = -SPEED
			$Sprite.flip_h = true
		"Right":
			motion.x = SPEED
			$Sprite.flip_h = false
		"LeftUp":
			motion.x = -SPEED
			$Sprite.flip_h = true
		"RightUp":
			motion.x = SPEED
			$Sprite.flip_h = false
	
	pass


func does_damage(damage):
	hp -= damage
	hp = max(0, hp)
	$anim.play("hit")
	update_hp()
	# Se o hp zerou, morre
	if !hp:
		dies()
	pass

func dies():
	$HP.set_visible(false)
	$anim.play("death")
	$Sounds/death.play()
	yield($anim,"animation_finished")
	yield($Sounds/death,"finished")
	queue_free()

func _on_Timer_timeout():
	timer.set_one_shot(false)

func restart_timer():
	timer.set_one_shot(true)
	timer.set_wait_time(1.0)
	timer.start()
	pass