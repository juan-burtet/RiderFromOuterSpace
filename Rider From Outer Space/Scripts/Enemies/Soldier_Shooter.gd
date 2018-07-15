# Soldier_Shooter.gd
extends KinematicBody2D

### Conjunto de animações ###
	# shot_right
	# shot_up
	# shot_rightUp
	# run

# Variaveis para ajeitar as sprites
export var RUN_OFFSET = Vector2(0,7)
export var UP_OFFSET = Vector2(0,5)
export var ORIGINAL_OFFSET = Vector2(0,0)

# Velocidade
export var SPEED = 150
# HP
export var MAXHP = 50
# Espera do tiro
export var WAIT_TIME = 1.5

onready var timer = $Timer

# Cenas das armas
const PISTOL_SCENE = preload("res://Scenes/Enemies/EnemyGun.tscn")

const UP = Vector2(0,-1)
const GRAVITY = 20

var motion = Vector2(0,0)
var hp

signal over

func _ready():
	$Sprite.set_offset(ORIGINAL_OFFSET)
	$Sprite.set_visible(true)
	
	hp = MAXHP
	$HP.set_max(MAXHP)
	update_hp()
	timer.set_one_shot(false)
	pass

func _process(delta):
	motion.y += GRAVITY
	
	if $Right.is_colliding():
		teste($Right)
	elif $Left.is_colliding():
		teste($Left)
	elif $Up.is_colliding():
		teste($Up)
	elif $LeftUp1.is_colliding():
		teste($LeftUp1)
	elif $RightUp1.is_colliding():
		teste($RightUp1)
	elif $LeftUp2.is_colliding():
		teste($LeftUp1)
	elif $RightUp2.is_colliding():
		teste($RightUp1)

	if motion.x > 0:
		$Sprite.flip_h = false
	elif motion.x < 0:
		$Sprite.flip_h = true

	motion = move_and_slide(motion, UP)
	pass

func restart_timer():
	timer.set_one_shot(true)
	timer.set_wait_time(WAIT_TIME)
	timer.start()

func _on_Timer_timeout():
	timer.set_one_shot(false)

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
	yield($anim,"animation_finished")
	queue_free()

func teste(node):
	if node.get_collider() != null:
		if node.get_collider().get_name() == "PlayerTest":
			movement(node.get_name())
			match node.get_name():
				"Left":
					shoot(Vector2(-1,0))
					motion.x = -SPEED
					pass
				"LeftUp1":
					shoot(Vector2(-1,-1))
					motion.x = -SPEED
					pass
				"LeftUp2":
					shoot(Vector2(-1,-1))
					motion.x = -SPEED
					pass
				"Right":
					shoot(Vector2(1,0))
					motion.x = SPEED
					pass
				"RightUp1":
					shoot(Vector2(1,-1))
					motion.x = SPEED
					pass
				"RightUp2":
					shoot(Vector2(1,-1))
					motion.x = SPEED
					pass
				"Up":
					shoot(Vector2(0,-1))
					motion.x = 0
					pass
	pass

func movement(dir):
	match dir:
		"Left":
			$Sprite.play("run")
			$Sprite.set_offset(RUN_OFFSET)
			pass
		"Right":
			$Sprite.play("run")
			$Sprite.set_offset(RUN_OFFSET)
			pass
		"Up":
			$Sprite.play("shot_up")
			$Sprite.set_offset(ORIGINAL_OFFSET)
			pass
		"RightUp1":
			$Sprite.play("shot_rightUp")
			$Sprite.set_offset(UP_OFFSET)
			pass
		"RightUp2":
			$Sprite.play("shot_rightUp")
			$Sprite.set_offset(UP_OFFSET)
			pass
		"LeftUp1":
			$Sprite.play("shot_rightUp")
			$Sprite.set_offset(UP_OFFSET)
			pass
		"LeftUp2":
			$Sprite.play("shot_rightUp")
			$Sprite.set_offset(UP_OFFSET)
			pass
	pass



func update_hp():
	$HP.set_value(hp)

func shoot(direction):
	if $Visibility.is_on_screen():
		if !timer.is_one_shot():
			var position
			match direction:
				# Right
				Vector2(1,0):
					position = $Gun_Positions/Right.get_global_position()
					pass
				# Left
				Vector2(-1,0):
					position = $Gun_Positions/Left.get_global_position()
					pass
				# Up
				Vector2(0,-1):
					position = $Gun_Positions/Up.get_global_position()
					pass
				# RightUp
				Vector2(1,-1):
					position = $Gun_Positions/UpRight.get_global_position()
					pass
				# LeftUp
				Vector2(-1,-1):
					position = $Gun_Positions/UpLeft.get_global_position()
					pass
			var pistol = PISTOL_SCENE.instance()
			pistol.init(direction)
			add_child(pistol)
			print(position)
			print(direction)
			pistol.set_position(position)
			restart_timer()