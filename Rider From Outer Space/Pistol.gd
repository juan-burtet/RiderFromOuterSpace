# Pistol.gd
extends Area2D

const SPEED = 900
var motion = Vector2()

func init(direction):
	motion = direction

func _ready():
	$Sounds/shoot.play()

func _process(delta):
	translate(motion * SPEED * delta)
	pass

func _on_Pistol_body_entered(body):
	$Collision.set_disabled(true)
	$Bullet.set_visible(false)
	if body.get_name() != "TileMap" and body.get_name() != "TileMap2":
		body.does_damage(global.get_pistol_damage())
	$Sounds/impact.play()
	yield($Sounds/impact,"finished")
	queue_free()
	pass

# Quando a bala sair da tela, ela é destruida
func _on_Visibility_screen_exited():
	queue_free()
	pass 
