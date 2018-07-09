extends CanvasLayer

func begin():
	$Animation.play("begin")
	yield($Animation, "animation_finished")
	pass

func end():
	$Animation.play("end")
	yield($Animation, "animation_finished")
	pass