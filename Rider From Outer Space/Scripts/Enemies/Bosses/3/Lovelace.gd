extends KinematicBody2D

const FIREBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon3.tscn")

const MAX_HP = 50
var hp 
var can_shot
var pos
onready var timer_atirar = $atirar
onready var timer_sequencia = $sequencia_tiros
signal dead

func _ready():
	pos = 0
	can_shot = true
	
	$Info/Name.set_text("LOVELACE, THE GUARDIAN")
	$Info/TextureProgress.set_max(MAX_HP)
	hp = MAX_HP
	
	update_hp()
	restart_timer_atirar()
	restart_timer_sequencia()
	pass

func _process(delta):
	if !timer_atirar.is_one_shot() and can_shot:
		$Sprite.play("Attack")
		restart_timer_atirar()
		var position = random_pos()
		shot(position)
		yield(timer_sequencia, "timeout")
		shot(position)
		yield(timer_sequencia, "timeout")
		shot(position)
		yield(timer_sequencia, "timeout")
		shot(position)
		yield(timer_sequencia, "timeout")
		shot(position)
		yield(timer_sequencia, "timeout")
		$Sprite.play("Idle")
		
	pass

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
	
	restart_timer_sequencia()


func random_pos():
	randomize()
	var random = randi()%3
	
	if random == pos:
		random += 1
		if random > 2:
			random = 0
	
	pos = random
	return pos

func does_damage(damage):
	$Animation.play("Damage")
	hp -= damage
	hp = max(0,hp)
	update_hp()
	is_dead()
	pass

func update_hp():
	$Info/TextureProgress.set_value(hp)

func is_dead():
	if !hp:
		can_shot = false
		$CollisionShape2D.queue_free()
		$Animation.play("Death")
		yield($Animation,"animation_finished")
		get_parent().queue_free()
		emit_signal("dead")

func _on_atirar_timeout():
	timer_atirar.set_one_shot(false)

func _on_sequencia_tiros_timeout():
	timer_sequencia.set_one_shot(false)

func restart_timer_atirar():
	timer_atirar.set_wait_time(2)
	timer_atirar.set_one_shot(true)
	timer_atirar.start()

func restart_timer_sequencia():
	timer_sequencia.set_wait_time(0.2)
	timer_sequencia.set_one_shot(true)
	timer_sequencia.start()