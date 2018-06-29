# MachineGun.gd
extends Area2D

const SPEED = 900
var motion = Vector2()
var damage = 5

# Inicialização
func init(direction):
	motion = direction

# Movimenta a bala
func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Quando a bala sair da tela, ela é destruida
func _on_Visibility_screen_exited():
	queue_free()

func _on_MachineGun_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap" and body.get_name() != "TileMap2":
		body.does_damage(damage)
