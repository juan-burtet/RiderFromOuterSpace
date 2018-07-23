extends KinematicBody2D

const FIREBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon4.tscn")
const SHADOWBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon5.tscn")

const MAX_HP = 16000
var hp 
var can_shot
var pos
onready var timer = $Timer
var mode

signal dead

func _ready():
	mode = 0
	pos = 0
	can_shot = true
	$Info/Name.set_text("CARMACK, THE OLD ONE")
	$Info/TextureProgress.set_max(MAX_HP)
	hp = MAX_HP
	update_hp()
	restart_timer()
	pass

func _process(delta):
	
	match mode:
		0:
			if !timer.is_one_shot() and can_shot:
				shot_all(random_pos(8))
		1:
			if !timer.is_one_shot() and can_shot:
				shot_shadow(random_pos(3))
	pass

func shot_shadow(pos):
	var fireball = SHADOWBALL_SCENE.instance()
	fireball.init(Vector2(-1,0))
	get_parent().add_child(fireball)
	match pos:
		0:
			fireball.set_position($Pos8.get_global_position())
		1:
			fireball.set_position($Pos9.get_global_position())
		2:
			fireball.set_position($Pos10.get_global_position())
	
	restart_timer_shadow()

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

func random_pos(x):
	randomize()
	var random = randi()%x
	
	if random == pos:
		random += 1
		if random > (x-1):
			random = 0
	
	pos = random
	return pos

func does_damage(damage):
	$Animation.play("damage")
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

func restart_timer_shadow():
	timer.set_wait_time(0.7)
	timer.set_one_shot(true)
	timer.start()

func is_dead():
	if !hp:
		can_shot = false
		$CollisionShape2D.set_disabled(true)
		if mode != 0:
			global.add_upgrades()
			$death.play()
			yield($death,"finished")
			$Animation.play("die")
			yield($Animation, "animation_finished")
			emit_signal("dead")
			get_parent().queue_free()
		else:
			
			var parent = get_parent()
			parent = parent.get_parent()
			parent.get_node("music").stop()
			mode = 1
			$Sprite.play("Death")
			$death.play()
			yield($Sprite, "animation_finished")
			$Sprite.flip_h = false
			$Sprite.play("Shadow_In")
			yield($Sprite, "animation_finished")
			hp = MAX_HP
			update_hp()
			$Sprite.play("Shadow_Idle")
			$CollisionShape2D.set_disabled(false)
			can_shot = true
			parent.get_node("music").play()
			restart_timer_shadow()

func _on_FinalBoss_apertou():
	pass # replace with function body
