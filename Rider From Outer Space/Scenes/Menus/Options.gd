extends Node

# Bus #
# 0 - Master
# 1 - SFX
# 2 - MUSIC

# is_bus_mute(int idx)
# set_bus_mute(int idx, bool enable)

var menu
var option
signal sound

var music_option
var sfx_option
var full_option

func on_menu():
	$Options.set_visible(true)
	$Music.set_visible(true)
	$Sfx.set_visible(true)
	$Fullscreen.set_visible(true)
	$Selected/Music.set_visible(true)
	$Selected/Sfx.set_visible(true)
	$Selected/Fullscreen.set_visible(true)
	set_process(true)
	pass

func off_menu():
	$Options.set_visible(false)
	$Music.set_visible(false)
	$Sfx.set_visible(false)
	$Fullscreen.set_visible(false)
	$Selected/Music.set_visible(false)
	$Selected/Sfx.set_visible(false)
	$Selected/Fullscreen.set_visible(false)
	set_process(false)

func _ready():
	music_option = get_music()
	sfx_option = get_sfx()
	full_option = get_full()
	
	menu = 0
	option = "music"
	var parent = get_parent()
	connect("sound", parent, "on_sound")
	update_sprites()
	pass

func _input(event):
	if event.is_action_pressed("ui_esc"):
		emit_signal("sound")
		get_parent().get_node("Principal").on_menu()
		off_menu()
	pass

func _process(delta):
	music_option = get_music()
	sfx_option = get_sfx()
	full_option = get_full()
	
	# move o menu
	move_menu()
	
	# decide qual é a opção escolhida
	option_selected()
	
	# Escolhe a opção
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
			menu = 2
	elif down:
		sound = true
		menu += 1
		if menu > 2:
			menu = 0
	
	if sound:
		update_sprites()
		emit_signal("sound")
	
	pass

func option_selected():
	match menu: 
		0:
			if music_option:
				$Selected/Music.play("select_on")
			else:
				$Selected/Music.play("select_off")
		1:
			if sfx_option:
				$Selected/Sfx.play("select_on")
			else:
				$Selected/Sfx.play("select_off")
		2:
			if full_option:
				$Selected/Fullscreen.play("select_on")
			else:
				$Selected/Fullscreen.play("select_off")
	pass

func update_sprites():
	if music_option:
		$Selected/Music.play("on")
	else:
		$Selected/Music.play("off")
	
	if sfx_option:
		$Selected/Sfx.play("on")
	else:
		$Selected/Sfx.play("off")
	
	if full_option:
		$Selected/Fullscreen.play("on")
	else:
		$Selected/Fullscreen.play("off")
	
	pass

func choose_option():
	match menu:
		0:
			if get_music():
				set_music(true)
			else:
				set_music(false)
		1:
			if get_sfx():
				set_sfx(true)
			else:
				set_sfx(false)
		2:
			if get_full():
				set_full(false)
			else:
				set_full(true)
	pass

func get_music():
	return not AudioServer.is_bus_mute(2)

func set_music(value):
	AudioServer.set_bus_mute(2, value)

func get_sfx():
	return not AudioServer.is_bus_mute(1)

func set_sfx(value):
	AudioServer.set_bus_mute(1, value)

func get_full():
	return OS.is_window_fullscreen()

func set_full(value):
	OS.set_window_fullscreen(value)

