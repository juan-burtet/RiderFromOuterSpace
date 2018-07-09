extends CanvasLayer

func init(name, color, text):
	$Name.set_text(name)
	$Name.set_modulate(color)
	$Text.set_text(text)

func begin(name, color, text):
	init(name, color, text)
	$Animation.play("fade_in")

func end():
	$Animation.play("fade_out")
	yield($Animation, "animation_finished")
	queue_free()