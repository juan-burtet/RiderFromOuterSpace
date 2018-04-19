extends Area2D

export(String, FILE, "*.tscn") var next_world

func _on_WorldComplete_body_entered(body):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		print(bodies)
		if body.name == "Player":
			get_tree().change_scene(next_world)
	pass # replace with function body
