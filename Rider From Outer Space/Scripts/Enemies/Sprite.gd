extends AnimatedSprite

signal attack
signal over

var is_on_attack

func _process(delta):
	is_on_attack = false
	if get_animation() == "Attack":
		if get_frame() == 7:
			emit_signal("attack")
			is_on_attack = true
			pass
		elif get_frame() == 10:
			emit_signal("over")
			is_on_attack = true
			pass
	
	pass

func get_is_on_attack():
	return is_on_attack