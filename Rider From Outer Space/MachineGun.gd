extends Area2D

const SPEED = 800
var motion = Vector2()

func init(direction):
	motion = direction

func _process(delta):
	translate(motion * SPEED * delta)

