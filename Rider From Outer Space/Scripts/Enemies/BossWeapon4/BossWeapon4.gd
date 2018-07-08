extends Area2D

# Velocidade da Bala
const SPEED = 125
# Direção da bala
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction
	set_process(true)

func _process(delta):
	translate(motion * SPEED * delta)
	pass

func _on_Visibility_screen_exited():
	queue_free()

func _on_BossWeapon4_body_entered(body):
	$Collision.queue_free()
	if body.get_name() != "TileMap":
		body.receive_damage()
	$Animation.play("destroy")
	yield($Animation, "animation_finished")
	queue_free()
