extends KinematicBody2D

const LIFE_POSITION = Vector2(0,-14)
const DEATH_POSITION = Vector2(0,-2)

const MAX_HP = 2000
var hp 


func _ready():
	hp = MAX_HP
	$Sprite.set_position(LIFE_POSITION)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func does_damage(damage):
	hp -= damage
	hp = max(0,hp)
	pass