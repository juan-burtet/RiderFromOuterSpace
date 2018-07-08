extends KinematicBody2D

const FIREBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon2.tscn")

const MAX_HP = 10
var hp 
var can_shot
var pos
onready var timer = $Timer

func _ready():
	pos = 0
	can_shot = true
	
	$Info/Name.set_text("TURING, THE WISE")
	$Info/TextureProgress.set_max(MAX_HP)
	hp = MAX_HP
	
	update_hp()
	restart_timer()
	pass

func _process(delta):
	if !timer.is_one_shot() and can_shot:
		print("atirou")
		shot_all(random_pos())
	pass

func shot_all(pos):
	match pos:
		0:
			shot(1)
			shot(2)
			shot(3)
			shot(4)
			shot(5)
			shot(6)
			shot(7)
		1:
			shot(0)
			shot(2)
			shot(3)
			shot(4)
			shot(5)
			shot(6)
			shot(7)
		2:
			shot(0)
			shot(1)
			shot(3)
			shot(4)
			shot(5)
			shot(6)
			shot(7)
		3:
			shot(0)
			shot(1)
			shot(2)
			shot(4)
			shot(5)
			shot(6)
			shot(7)
		4:
			shot(0)
			shot(1)
			shot(2)
			shot(3)
			shot(5)
			shot(6)
			shot(7)
		5:
			shot(0)
			shot(1)
			shot(2)
			shot(3)
			shot(4)
			shot(6)
			shot(7)
		6:
			shot(0)
			shot(1)
			shot(2)
			shot(3)
			shot(4)
			shot(5)
			shot(7)
		7:
			shot(0)
			shot(1)
			shot(2)
			shot(3)
			shot(4)
			shot(5)
			shot(6)
	
	restart_timer()
	pass

func shot(pos):
	var fireball = FIREBALL_SCENE.instance()
	fireball.init(Vector2(0,1))
	get_parent().add_child(fireball)
	match pos:
		0:
			fireball.set_position($Pos0.get_global_position())
		1:
			fireball.set_position($Pos1.get_global_position())
		2:
			fireball.set_position($Pos2.get_global_position())
		3:
			fireball.set_position($Pos3.get_global_position())
		4:
			fireball.set_position($Pos4.get_global_position())
		5:
			fireball.set_position($Pos5.get_global_position())
		6:
			fireball.set_position($Pos6.get_global_position())
		7:
			fireball.set_position($Pos7.get_global_position())

func random_pos():
	randomize()
	var random = randi()%8
	
	if random == pos:
		random += 1
		if random > 7:
			random = 0
	
	pos = random
	return pos

func does_damage(damage):
	$AnimationPlayer.play("damage")
	hp -= damage
	hp = max(0,hp)
	update_hp()
	is_dead()
	pass

func _on_Timer_timeout():
	timer.set_one_shot(false)

func update_hp():
	$Info/TextureProgress.set_value(hp)

func restart_timer():
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	timer.start()

func is_dead():
	if !hp:
		can_shot = false
		$AnimationPlayer.play("death")
		yield($AnimationPlayer, "animation_finished")
		get_parent().queue_free()