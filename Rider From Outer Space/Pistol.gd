# Pistol.gd
extends Area2D

const SPEED = 900
var motion = Vector2()

func init(direction):
	motion = direction

func _ready():
	set_process(true)

func _process(delta):
	translate(motion * SPEED * delta)
	pass

# Destroi o tiro quando ele sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Pistol_area_entered(area):
	#area.queue_free()
	queue_free()
	pass

func _on_Pistol_body_entered(body):
	#queue_free()
	#if body.get_name() != "TileMap":
	#	body.queue_free()
	pass # replace with function body
