# BossLevel2.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const TEXT1 = "FINALLY!" 
const TEXT2 = "HELLO, RIDER."
const TEXT3 = "HOW DO YOU KNOW MY NAME?"
const TEXT4 = "I HAVE THE CURSE OF KNOWLEDGE. I HAVE THE ANSWER FOR ALL YOUR QUESTIONS..."
const TEXT5 = "OKAY. I NEED TO KNOW WHERE IS THE GEM."
const TEXT6 = "I KNOW WHERE THE GEM ARE. SADLY, I CAN'T TELL YOU WHERE IT IS. YOU NEED TO DIE."
const TEXT7 = "BRING IT ON!"

const TEXT8 = "GO TO BYRON. THE GEM IS THERE. FIND THE TEMPLE. FIND LOVELACE"
const TEXT9 = "TIME TO GO TO BYRON."


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
	$Boss/Turing.set_process(false)
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
	cria_dialogo("TURING", green, TEXT2)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT3)
	yield(self, "acabou")
	cria_dialogo("TURING", green, TEXT4)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT5)
	yield(self, "acabou")
	cria_dialogo("TURING", green, TEXT6)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT7)
	yield(self, "acabou")
	
	dialog.queue_free()
	
	$begin.play()
	dialogo = false
	$PlayerTest.set_physics_process(true)
	#$Boss/Turing.restart_timer()

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

func _on_Turing_dead():
	$PlayerTest.set_physics_process(false)
	$PlayerTest.set_process(true)
	end()
	yield(self, "fade")
	dialogo = true
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
	cria_dialogo("TURING", green, TEXT8)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT9)
	$Timer.set_wait_time(0.5)
	$Timer.start()
	yield($Timer,"timeout")
	yield(self, "acabou")
	
	dialogo = false
	emit_signal("termina_fase")


func _on_begin_finished():
	$Boss/Turing.set_process(true)
	$music.play()


func _on_music_finished():
	$music.play()
