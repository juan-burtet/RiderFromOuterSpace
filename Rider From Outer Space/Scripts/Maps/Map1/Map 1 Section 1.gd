# Map 1 Section 1.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const TEXT1 = "THIS IS THE LOCATION OF THE PLANET KONISBERG."
const TEXT2 = "NOW I HAVE TO FIND DJIKSTRA."

var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)
var green = Color(0,1,0,1)
var blue = Color(0,0,1,1)

var dialog
signal acabou
signal apertou
signal fade

func _ready():
	begin()
	yield(self, "fade")
	$PlayerTest.set_physics_process(false)
	inicia_dialogo()
	pass

func _on_ChangeLevel_next_world():
	end()
	yield(self, "fade")
	global.set_loadgame(next_world)
	get_tree().change_scene(next_world)

func cria_dialogo(name, color, text):
	dialog.init(name,color,text)
	dialog.get_node("Animation").play("fade_in")
	yield(dialog.get_node("Animation"), "animation_finished")
	yield(self, "apertou")
	dialog.get_node("Animation").play("fade_out")
	yield(dialog.get_node("Animation"), "animation_finished")
	emit_signal("acabou")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("apertou")

func inicia_dialogo():
	# dialogos
	dialog = DIALOG_SCENE.instance()
	self.add_child(dialog)
	cria_dialogo("RIDER", yellow, TEXT1)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT2)
	yield(self, "acabou")
	
	$music.play()
	$PlayerTest.set_physics_process(true)

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
	black.queue_free()
	emit_signal("fade")

func _on_music_finished():
	$music.play()
