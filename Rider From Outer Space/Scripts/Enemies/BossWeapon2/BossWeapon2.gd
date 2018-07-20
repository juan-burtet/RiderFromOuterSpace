extends Area2D

# Velocidade da Bala
const SPEED = 200
# Direção da bala
var motion = Vector2()

# Inicialização
func init(direction):
	motion = direction
	set_process(true)

func _ready():
	$Sounds/shoot.play()
	pass


func _process(delta):
	translate(motion * SPEED * delta)
	pass

func _on_Visibility_screen_entered():
	print("sumiu")
	#queue_free()

func _on_BossWeapon2_body_entered(body):
	$Collision.set_disabled(true)
	if body.get_name() == "PlayerTest":
			body.receive_damage()
	$anim.play("destroy")
	$Sounds/impact.play()
	yield($anim, "animation_finished")
	yield($Sounds/impact,"finished")
	queue_free()
