extends KinematicBody2D

const MAX_HP = 2000
var hp 

func _ready():
	$Info/Name.set_text("LOVELACE, THE GUARDIAN")
	$Info/TextureProgress.set_max(MAX_HP)
	hp = MAX_HP
	pass

func _process(delta):
	$Info/TextureProgress.set_value(hp)
	pass

func does_damage(damage):
	hp -= damage
	hp = max(0,hp)
	pass