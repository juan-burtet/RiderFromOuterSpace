extends Area2D

func _on_MasterUpgrade_body_entered(body):
	if body.get_name() == "PlayerTest":
		global.add_upgrades()
		destroy_masterUpgrade()
	pass # replace with function body

func destroy_masterUpgrade():
	$CollisionShape2D.set_disabled(true)
	$Sprite.set_visible(false)
	$destroy.play()
	yield($destroy,"finished")
	queue_free()