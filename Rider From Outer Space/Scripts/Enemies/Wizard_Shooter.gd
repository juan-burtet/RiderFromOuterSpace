# Wizard_Shooter.gd
extends KinematicBody2D

# HP
export var MAXHP = 50
# Espera do tiro
export var WAIT_TIME = 1.5

onready var timer = $Timer

# Cenas das armas
const PISTOL_SCENE = preload("res://Scenes/Enemies/WizardBall.tscn")

const UP = Vector2(0,-1)
const GRAVITY = 20

var motion = Vector2(0,0)
var hp

signal over

func _ready():
	hp = MAXHP
	$HP.set_max(MAXHP)
	update_hp()
	timer.set_one_shot(false)
	$Sprite.play("idle")
	timer.set_one_shot(false)
	pass

func _process(delta):
	motion.y += GRAVITY
	
	if !timer.is_one_shot():
		if $Right.is_colliding():
			teste($Right)
		elif $Left.is_colliding():
			teste($Left)
		elif $Up.is_colliding():
			teste($Up)
		elif $LeftUp.is_colliding():
			teste($LeftUp)
		elif $RightUp.is_colliding():
			teste($RightUp)
	
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
	set_process(false)
	$Collision.set_disabled(true)
	$HP.set_visible(false)
	$anim.play("death")
	$Sounds/death.play()
	yield($anim,"animation_finished")
	yield($Sounds/death,"finished")
	queue_free()

func teste(node):
	if node.get_collider() != null:
		print(node.get_collider())
		if node.get_collider().get_name() == "PlayerTest":
			match node.get_name():
				"Left":
					shoot(Vector2(-1,0))
					$Sprite.flip_h = false
					pass
				"LeftUp":
					shoot(Vector2(-1,-1))
					$Sprite.flip_h = false
					pass
				"Right":
					shoot(Vector2(1,0))
					$Sprite.flip_h = true
					pass
				"RightUp":
					shoot(Vector2(1,-1))
					$Sprite.flip_h = true
					pass
				"Up":
					shoot(Vector2(0,-1))
					pass
	pass

func update_hp():
	$HP.set_value(hp)

func shoot(direction):
	if $Visibility.is_on_screen():
		print(direction)
		timer.set_one_shot(true)
		$Sprite.play("attack")
		yield($Sprite, "over")
		var position
		var pistol = PISTOL_SCENE.instance()
		pistol.init(direction)
		get_parent().add_child(pistol)
		pistol.set_position($Gun.get_global_position() + direction*10)
		restart_timer()
	pass
