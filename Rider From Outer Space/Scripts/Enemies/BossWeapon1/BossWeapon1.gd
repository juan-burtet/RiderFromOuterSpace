extends Area2D

# Velocidade da Bala
const SPEED = 300
# Direção da bala
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction
	set_process(true)

func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Destroi a bala quando sair da tela
func _on_Visibility_screen_exited():
	queue_free()

func _on_BossWeapon1_body_entered(body):
	queue_free()
	if body.get_name() != "TileMap":
		body.receive_damage()
