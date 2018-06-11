# EnemyGun.gd
extends Area2D

# Velocidade da Bala
const SPEED = 400
# Direção da bala
var motion = Vector2()

# Inicialização da direção
func init(direction):
	motion = direction

func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Destroi a bala quando sair da tela
func _on_Visibility_screen_exited():
	queue_free()


func _on_EnemyGun_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		print("acertou o personagem")
