extends Area2D

func _on_Coins_body_entered(body):
	if body.get_name() == "PlayerTest":
		global.imprime()
		global.add_coin()
		destroy_coin()
	pass # replace with function body

func destroy_coin():
	$CollisionShape2D.set_disabled(true)
	$Sprite.set_visible(false)
	$destroy.play()
	yield($destroy,"finished")
	queue_free()
	pass