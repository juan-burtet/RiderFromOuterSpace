# BossLevel1.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const TEXT1 = "ARE YOU THE GREAT WIZARD DJIKSTRA?"
const TEXT2 = "WHO ARE YOU?!?"
const TEXT3 = "I NEED TO FIND THE GEM, CARMACK TOLD ME YOU KNOW THE LOCATION!"
const TEXT4 = "CARMACK IS TRYING TO FIND THE GEM? I WILL NEVER TELL THE LOCATION! NOBODY COULD PUT THE HANDS IN THE GEM! NOBODY! PREPARE TO DIE!"
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
signal fade
signal termina_fase

var dialogo
var largou

func _ready():
	$PlayerTest.set_physics_process(false)
	$PlayerTest.set_process(true)
	$PlayerTest/camera.queue_free()
	$Boss/Djikstra.set_process(false)
	begin()
	yield(self, "fade")
	dialogo = true
	largou = true
	$PlayerTest.set_process(false)
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
	cria_dialogo("DJIKSTRA", blue, TEXT2)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT3)
	yield(self, "acabou")
	cria_dialogo("DJIKSTRA", blue, TEXT4)
	yield(self, "acabou")
	dialog.queue_free()
	
	$begin.play()
	dialogo = false

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

func _on_Djikstra_dead():
	$PlayerTest.set_physics_process(false)
	$PlayerTest.set_process(true)
	end()
	yield(self, "fade")
	$PlayerTest.queue_free()
	
	dialogo = true
	cria_dialogo_fim()
	yield(self, "termina_fase")
	change_level()
	pass # replace with function body

func change_level():
	global.set_loadgame(next_world)
	global.set_map2()
	get_tree().change_scene(next_world)

func cria_dialogo_fim():
	# dialogos
	$music.stop()
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
	
	dialogo = false
	emit_signal("termina_fase")

func _on_begin_finished():
	$PlayerTest.set_physics_process(true)
	$Boss/Djikstra.set_process(true)
	$music.play()


func _on_music_finished():
	$music.play()
