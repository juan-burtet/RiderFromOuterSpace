extends Area2D

func _on_MasterUpgrade_body_entered(body):
	if body.get_name() == "PlayerTest":
		destroy_masterUpgrade()
	pass # replace with function body

func destroy_masterUpgrade():
	queue_free()