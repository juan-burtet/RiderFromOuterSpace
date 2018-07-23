extends Sprite

const firstLevel = "res://Scenes/Prelude/Prelude.tscn"


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene(firstLevel)
