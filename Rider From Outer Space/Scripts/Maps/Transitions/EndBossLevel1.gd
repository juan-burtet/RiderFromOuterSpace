extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")

const TEXT5 = "IT IS OVER! TELL ME ABOUT THE GEM"
const TEXT6 = "THE ANSWER YOU LOOKING FOR IS IN THE PLANET NALA. FIND THE WISE TURING, HE KNOW WHERE THE GEM ARE!"
const TEXT7 = "TIME TO GO TO NALA!"

var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)
var green = Color(0,1,0,1)
var blue = Color(0,0,1,1)

var dialog

signal acabou
signal apertou

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("apertou")
	pass


func _ready():
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	cria_dialogo("RIDER", yellow, TEXT5)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	cria_dialogo("DJIKSTRA", blue, TEXT6)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT7)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	
	global.set_loadgame(next_world)
	global.set_map2()
	get_tree().change_scene(next_world)
	pass

func cria_dialogo(name, color, text):
	dialog.init(name,color,text)
	dialog.get_node("Animation").play("fade_in")
	yield(dialog.get_node("Animation"), "animation_finished")
	yield(self, "apertou")
	dialog.get_node("Animation").play("fade_out")
	yield(dialog.get_node("Animation"), "animation_finished")
	emit_signal("acabou")