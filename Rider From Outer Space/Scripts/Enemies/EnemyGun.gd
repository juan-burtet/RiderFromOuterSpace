# EnemyGun.gd
extends Area2D

# Velocidade da Bala
const SPEED = 300
# Direção da bala
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction
	set_process(true)

func _ready():
	$Sounds/shoot.play()

func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Destroi a bala quando sair da tela
func _on_Visibility_screen_exited():
	queue_free()

func _on_EnemyGun_body_entered(body):
	$Collision.set_disabled(true)
	$Bullet.set_visible(false)
	if body.get_name() == "PlayerTest":
			body.receive_damage()
	$Sounds/impact.play()
	yield($Sounds/impact, "finished")
	queue_free()
