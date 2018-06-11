extends Node

const firstLevel = "res://Scenes/Maps/Map 1/Section 1/Map 1 Section 1.tscn"

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene(firstLevel)
		pass
	pass
