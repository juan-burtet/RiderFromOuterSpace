extends Node

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")

const text1 = "Meu nome eh tiaguinho"

var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)

var dialog
signal acabou
signal apertou

func _ready():
	$PlayerTest/camera.queue_free()
	$Boss/Carmack.set_process(false)
	$PlayerTest.set_physics_process(false)
	inicia_dialogo()
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("apertou")

func inicia_dialogo():
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	cria_dialogo("Jaeger", yellow, text1)
	yield(self, "acabou")
	cria_dialogo("Carmack", Color(1,0,0,1), "CHUPA MEU PIRU")
	yield(self, "acabou")
	
	$Boss/Carmack.set_process(true)
	$PlayerTest.set_physics_process(true)

func cria_dialogo(name, color, text):
	dialog.init(name,color,text)
	dialog.get_node("Animation").play("fade_in")
	yield(dialog.get_node("Animation"), "animation_finished")
	yield(self, "apertou")
	dialog.get_node("Animation").play("fade_out")
	yield(dialog.get_node("Animation"), "animation_finished")
	emit_signal("acabou")

func _on_Carmack_dead():
	print("is over!")