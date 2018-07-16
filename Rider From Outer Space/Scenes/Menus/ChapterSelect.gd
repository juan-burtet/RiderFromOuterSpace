extends Node

const KONISBERG = "res://Scenes/Maps/Map 1/Section 1/Map 1 Section 1.tscn"
const NALA = "res://Scenes/Maps/Map 2/Section 1/Map 2 Section 1.tscn"
const BYRON = "res://Scenes/Maps/Map 3/Section 1/Map 3 Section 1.tscn"
const CARMACK = "res://Scenes/Maps/Final Boss/FinalBoss.tscn"

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
	if global.get_map1():
		$Map1.play("konisberg")
	else:
		$Map1.play("unable")
	
	if global.get_map2():
		$Map2.play("nala")
	else:
		$Map2.play("unable")
	
	if global.get_map3():
		$Map3.play("byron")
	else:
		$Map3.play("unable")
	
	if global.get_map4():
		$Map4.play("carmack")
	else:
		$Map4.play("unable")

func option_selected():
	match menu:
		0:
			if global.get_map1():
				$Map1.play("konisberg_on")
			else:
				$Map1.play("unable_on")
		1:
			if global.get_map2():
				$Map2.play("nala_on")
			else:
				$Map2.play("unable_on")
		2:
			if global.get_map3():
				$Map3.play("byron_on")
			else:
				$Map3.play("unable_on")
		3:
			if global.get_map4():
				$Map4.play("carmack_on")
			else:
				$Map4.play("unable_on")
	pass

func choose_option():
	match menu:
		0:
			if global.get_map1():
				get_tree().change_scene(KONISBERG)
			else:
				$anim.play("map1")
		1:
			if global.get_map2():
				get_tree().change_scene(NALA)
			else:
				$anim.play("map2")
		2:
			if global.get_map3():
				get_tree().change_scene(BYRON)
			else:
				$anim.play("map3")
		3:
			if global.get_map4():
				get_tree().change_scene(CARMACK)
			else:
				$anim.play("map4")
	pass
















