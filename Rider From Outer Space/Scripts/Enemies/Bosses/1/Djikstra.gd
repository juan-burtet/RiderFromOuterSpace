extends KinematicBody2D

const LIFE_POSITION = Vector2(0,-14)
const DEATH_POSITION = Vector2(0,-2)
const FIREBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon1.tscn")

const MAX_HP = 50

signal dead
var hp
var can_shot
var pos
onready var timer = $Timer 

func _ready():
	pos = 0
	can_shot = true
	hp = MAX_HP
	$Sprite.set_position(LIFE_POSITION)
	$Info/Name.set_text("DJIKSTRA, THE WIZARD")
	$Info/TextureProgress.set_max(MAX_HP)
	update_hp()
	restart_timer()
	pass

func _process(delta):
	
	if !timer.is_one_shot() and can_shot:
		shot(random_pos())
	
	pass

func random_pos():
	randomize()
	var random = randi()%3
	
	if random == pos:
		random += 1
		if random > 2:
			random = 0
	
	pos = random
	return pos

func shot(pos):
	var fireball = FIREBALL_SCENE.instance()
	fireball.init(Vector2(-1,0))
	get_parent().add_child(fireball)
	match pos:
		0:
			fireball.set_position($Pos0.get_global_position())
			print(0)
		1:
			fireball.set_position($Pos1.get_global_position())
			print(1)
		2:
			fireball.set_position($Pos2.get_global_position())
			print(2)
	
	restart_timer()

func restart_timer():
	timer.set_wait_time(0.7)
	timer.set_one_shot(true)
	timer.start()

func _on_Timer_timeout():
	timer.set_one_shot(false)
	pass # replace with function body

func is_dead():
	if !hp:
		can_shot = false
		$Sprite.set_position(DEATH_POSITION)
		$Sprite.play("Death")
		yield($Sprite, "animation_finished")
		get_parent().queue_free()
		emit_signal("dead")

func update_hp():
	$Info/TextureProgress.set_value(hp)

func does_damage(damage):
	$Animation.play("damage")
	hp -= damage
	hp = max(0,hp)
	update_hp()
	is_dead()
	pass
