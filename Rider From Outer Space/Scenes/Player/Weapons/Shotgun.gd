# Shotgun.gd
extends Area2D

const SPEED = 700
var motion = Vector2()

func _ready():
	$Sounds/shoot.play()


# Inicialização
func init(direction):
	motion = direction
	# CIMA
	if direction.x == 0 and direction.y == -1:
		rotate_sprite(-PI/2)
	# CIMA + DIRETA
	elif direction.x == 1 and direction.y == -1:
		rotate_sprite(-PI/4)
	# DIREITA
	elif direction.x == 1 and direction.y == 0:
		rotate_sprite(0)
	# BAIXO + DIREITA
	elif direction.x == 1 and direction.y == 1:
		rotate_sprite(PI/4)
	# BAIXO
	elif direction.x == 0 and direction.y == 1:
		rotate_sprite(PI/2)
	# BAIXO + ESQUERDA
	elif direction.x == -1 and direction.y == 1:
		rotate_sprite(PI -PI/4)
	# ESQUERDA
	elif direction.x == -1 and direction.y == 0:
		rotate_sprite(PI)
	# CIMA + ESQUERDA
	elif direction.x == -1 and direction.y == -1:
		rotate_sprite(PI +PI/4)
	

# Movimenta a bala
func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Quando a bala sair da tela, ela é destruida
func _on_Visibility_screen_exited():
	queue_free()

func rotate_sprite(x):
	$Bullet.rotate(x)

func _on_Shotgun_body_entered(body):
	$Bullet.set_visible(false)
	$CollisionPolygon2D.set_disabled(true)
	
	if body.get_name() != "TileMap" and body.get_name() != "TileMap2":
		body.does_damage(global.get_shotgun_damage())
	$Sounds/impact.play()
	yield($Sounds/impact,"finished")
	queue_free()

