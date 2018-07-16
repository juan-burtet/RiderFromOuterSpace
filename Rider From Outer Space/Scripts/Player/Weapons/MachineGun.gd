# MachineGun.gd
extends Area2D

const SPEED = 900
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction

func _ready():
	$Sounds/shoot.play()
	pass

# Movimenta a bala
func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Quando a bala sair da tela, ela é destruida
func _on_Visibility_screen_exited():
	queue_free()

func _on_MachineGun_body_entered(body):
	$Collision.set_disabled(true)
	$Bullet.set_visible(false)
	if body.get_name() != "TileMap" and body.get_name() != "TileMap2":
		body.does_damage(global.get_machinegun_damage())
	$Sounds/impact.play()
	yield($Sounds/impact,"finished")
	queue_free()
	