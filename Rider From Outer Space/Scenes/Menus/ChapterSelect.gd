extends Node

var menu
signal sound

func on_menu():
	$ChapterSelect.set_visible(true)
	$Map1.set_visible(true)
	$Map2.set_visible(true)
	$Map3.set_visible(true)
	$Map4.set_visible(true)
	set_process(true)

func off_menu():
	$ChapterSelect.set_visible(false)
	$Map1.set_visible(false)
	$Map2.set_visible(false)
	$Map3.set_visible(false)
	$Map4.set_visible(false)
	set_process(false)

func _ready():
	menu = 0
	update_sprites()
	var parent = get_parent()
	connect("sound", parent, "on_sound")
	pass

func _input(event):
	if event.is_action_pressed("ui_esc"):
		emit_signal("sound")
		get_parent().get_node("Principal").on_menu()
		off_menu()
	pass

func _process(delta):
	move_menu()
	
	
	option_selected()
	
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("sound")
		choose_option()
	pass

func move_menu():
	var sound = false
	var up = Input.is_action_just_pressed("ui_upMenu")
	var down = Input.is_action_just_pressed("ui_downMenu")
	
	if up:
		sound = true
		menu -= 1
		if menu < 0:
			menu = 3
		pass
	elif down:
		sound = true
		menu += 1
		if menu > 3:
			menu = 0
		pass
	
	if sound:
		update_sprites()
		emit_signal("sound")
	pass

func update_sprites():
	$Map1.play("unable")
	$Map2.play("unable")
	$Map3.play("unable")
	$Map4.play("unable")

func option_selected():
	match menu:
		0:
			$Map1.play("unable_on")
		1:
			$Map2.play("unable_on")
		2:
			$Map3.play("unable_on")
		3:
			$Map4.play("unable_on")
	pass

func choose_option():
	match menu:
		0:
			$anim.play("map1")
		1:
			$anim.play("map2")
		2:
			$anim.play("map3")
		3:
			$anim.play("map4")
	pass
















