extends Node

export(String, FILE, "*.tscn") var next_world

func _on_ChangeLevel_next_world():
	get_tree().change_scene(next_world)