extends Area2D

signal next_world

func _on_ChangeLevel_body_entered(body):
	emit_signal("next_world")
