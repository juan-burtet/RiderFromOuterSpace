# FinalBoss.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const TEXT1 = "HERE IS THE GEM." 
const TEXT2 = "VERY GOOD, RIDER... VERY GOOD."
const TEXT3 = "WHERE IS MY MONEY?"
const TEXT4 = "THERE IS NO MONEY, RIDER. THE ONLY THING I NEEDED WAS THE GEM. NOW, NO ONE CAN'T STOP ME. THANK YOU FOR YOUR HELP RIDER, NOW, YOU MUST DIE."
const TEXT5 = "I CAN STOP YOU! YOU GONNA DIE CARMACK!"
const TEXT6 = "HAHAHAHAHAHAHAHAHAHA!"

const TEXT8 = "NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!"
const TEXT9 = "THE GEM IS SAFE..."
const TEXT10 = "... FOR NOW."


var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)
var green = Color(0,1,0,1)
var blue = Color(0,0,1,1)
var purple = Color(1,0,1,1)

var dialog
signal acabou
signal apertou
signal fade
signal termina_fase

var dialogo
var largou

func _ready():
	$Boss/Carmack/Info/TextureProgress.set_visible(false)
	$Boss/Carmack/Info/Name.set_visible(false)
	$PlayerTest/camera.queue_free()
	$Boss/Carmack.set_process(false)
	$PlayerTest.set_physics_process(false)
	$PlayerTest.set_process(true)
	begin()
	yield(self, "fade")
	$PlayerTest.set_process(false)
	dialogo = true
	largou = true
	inicia_dialogo()
	pass

func cria_dialogo(name, color, text):
	dialog.init(name,color,text)
	dialog.get_node("Animation").play("fade_in")
	yield(dialog.get_node("Animation"), "animation_finished")
	yield(self, "apertou")
	dialog.get_node("Animation").play("fade_out")
	yield(dialog.get_node("Animation"), "animation_finished")
	emit_signal("acabou")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("apertou")

func inicia_dialogo():
	# dialogos
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	cria_dialogo("RIDER", yellow, TEXT1)
	yield(self, "acabou")
	cria_dialogo("CARMACK", purple, TEXT2)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT3)
	yield(self, "acabou")
	cria_dialogo("CARMACK", purple, TEXT4)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT5)
	yield(self, "acabou")
	cria_dialogo("CARMACK", purple, TEXT6)
	yield(self, "acabou")
	
	dialog.queue_free()
	
	$music.play()
	dialogo = false
	$PlayerTest.set_physics_process(true)
	$Boss/Carmack.set_process(true)
	$Boss/Carmack.restart_timer()
	$Boss/Carmack/Info/TextureProgress.set_visible(true)
	$Boss/Carmack/Info/Name.set_visible(true)

func begin():
	var black = BLACK_SCREEN.instance()
	add_child(black)
	black.get_node("Animation").play("begin")
	yield(black.get_node("Animation"), "animation_finished")
	black.queue_free()
	emit_signal("fade")

func end():
	var black = BLACK_SCREEN.instance()
	add_child(black)
	black.get_node("Animation").play("end")
	yield(black.get_node("Animation"), "animation_finished")
	emit_signal("fade")

func _on_Carmack_dead():
	$PlayerTest.set_physics_process(false)
	$PlayerTest.set_process(true)
	end()
	yield(self, "fade")
	dialogo = true
	cria_dialogo_fim()
	yield(self, "termina_fase")
	change_level()
	pass # replace with function body

func change_level():
	get_tree().change_scene(next_world)

func cria_dialogo_fim():
	# dialogos
	$music.stop()
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	cria_dialogo("CARMACK", purple, TEXT8)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	cria_dialogo("RIDER", yellow, TEXT9)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	cria_dialogo("RIDER", yellow, TEXT10)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	
	dialogo = false
	emit_signal("termina_fase")

func _on_music_finished():
	$music.play()
