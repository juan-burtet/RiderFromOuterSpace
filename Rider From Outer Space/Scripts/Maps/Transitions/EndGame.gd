extends Sprite

const MENU = "res://Scenes/Menus/MainMenu.tscn"

func _ready():
	$anim.play("loop")
	$music.play()
	pass

func _on_music_finished():
	get_tree().change_scene(MENU)
