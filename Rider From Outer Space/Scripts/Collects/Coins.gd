extends Area2D

func _on_Coins_body_entered(body):
	if body.get_name() == "PlayerTest":
		destroy_coin()
	pass # replace with function body

func destroy_coin():
	queue_free()
	pass