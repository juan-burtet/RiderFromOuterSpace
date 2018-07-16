# BossLevel3.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const TEXT1 = "YOU MUST BE LOVELACE" 
const TEXT2 = "ANOTHER VISITOR."
const TEXT3 = "GIVE THE GEM!"
const TEXT4 = "THE GEM MUST BE IN THE TEMPLE."
const TEXT5 = "I DON'T CARE. I NEED THE GEM. NOW!"
const TEXT6 = "LOVELACE MUST KILL ANYONE WHO TRIES TO STOLE THE GEM. PREPARE TO DIE"

const TEXT8 = "PLEASE. LEAVE THE GEM. IT'S NOT SAFE"


var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)
var green = Color(0,1,0,1)
var blue = Color(0,0,1,1)

var dialog
signal acabou
signal apertou
signal fade
signal termina_fase

var dialogo
var largou

func _ready():
	$PlayerTest/camera.queue_free()
	$Boss/Lovelace.set_process(false)
	begin()
	yield(self, "fade")
	$PlayerTest.set_physics_process(false)
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
	cria_dialogo("LOVELACE", red, TEXT2)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT3)
	yield(self, "acabou")
	cria_dialogo("LOVELACE", red, TEXT4)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT5)
	yield(self, "acabou")
	cria_dialogo("LOVELACE", red, TEXT6)
	yield(self, "acabou")
	
	dialog.queue_free()
	
	dialogo = false
	$PlayerTest.set_physics_process(true)
	$Boss/Lovelace.set_process(true)
	$Boss/Lovelace.restart_timer_atirar()

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

func _on_Lovelace_dead():
	end()
	yield(self, "fade")
	dialogo = true
	cria_dialogo_fim()
	yield(self, "termina_fase")
	change_level()
	pass # replace with function body

func change_level():
	global.set_loadgame(next_world)
	global.set_map4()
	get_tree().change_scene(next_world)

func cria_dialogo_fim():
	# dialogos
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	cria_dialogo("LOVELACE", red, TEXT8)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	
	dialogo = false
	emit_signal("termina_fase")