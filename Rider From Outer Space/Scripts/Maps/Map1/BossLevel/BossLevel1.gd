extends Node

func _ready():
	$PlayerTest/camera.queue_free()
	#$PlayerTest.set_can_move(false)
	#$PlayerTest.set_physics_process(false)
	#$PlayerTest.set_process(true)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass