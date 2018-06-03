# Pistol.gd
extends Area2D

const SPEED = 900
var motion = Vector2()

func init(direction):
	motion = direction

func _ready():
	set_process(true)

func _process(delta):
	#set_position(get_position() + motion * SPEED * delta)
	translate(motion * SPEED * delta)

# Destroi o tiro quando ele sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Pistol_area_entered(area):
	print("Entrou!")
	pass
