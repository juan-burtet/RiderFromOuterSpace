# Sprite_wizard.gd
extends AnimatedSprite

signal over

func _process(delta):
	if get_animation() == "attack":
		if get_frame() == 5:
			emit_signal("over")
			play("idle")
			pass
	pass
