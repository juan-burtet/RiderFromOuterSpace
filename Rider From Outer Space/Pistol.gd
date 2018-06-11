# Pistol.gd
extends Area2D

const SPEED = 900
var motion = Vector2()

func init(direction):
	motion = direction

func _process(delta):
	translate(motion * SPEED * delta)
	pass

func _on_Pistol_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.queue_free()
	pass

# Quando a bala sair da tela, ela é destruida
func _on_Visibility_screen_exited():
	queue_free()
	pass 
