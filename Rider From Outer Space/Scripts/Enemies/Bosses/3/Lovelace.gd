extends KinematicBody2D

const FIREBALL_SCENE = preload("res://Scenes/Enemies/BossWeapon3.tscn")

const MAX_HP = 2000
var hp 
var can_shot
var pos
onready var timer_atirar = $atirar
onready var timer_sequencia = $sequencia_tiros

func _ready():
	pos = 0
	can_shot = true
	
	$Info/Name.set_text("LOVELACE, THE GUARDIAN")
	$Info/TextureProgress.set_max(MAX_HP)
	hp = MAX_HP
	
	update_hp()
	restart_timer()
	pass

func _process(delta):
	$Info/TextureProgress.set_value(hp)
	pass

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
		get_parent().queue_free()

func _on_atirar_timeout():
	timer_atirar.set_one_shot(false)

func _on_sequencia_tiros_timeout():
	timer_sequencia.set_one_shot(false)

func restart_timer_atirar():
	timer_atirar.set_wait_time(3)
	timer_atirar.set_one_shot(true)
	timer_atirar.start()

func restart_timer_sequencia():
	timer_sequencia.set_wait_time(3)
	timer_sequencia.set_one_shot(true)
	timer_sequencia.start()