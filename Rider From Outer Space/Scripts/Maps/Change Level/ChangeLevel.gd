extends Area2D

export(String, FILE, "*.tscn") var next_world

func _on_ChangeLevel_body_entered(body):
	get_tree().change_scene(next_world)
