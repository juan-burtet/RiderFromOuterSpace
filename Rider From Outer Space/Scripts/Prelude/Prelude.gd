# Map 3 Section 1.gd
extends Node

export(String, FILE, "*.tscn") var next_world

const DIALOG_SCENE = preload("res://Scenes/Dialog/Dialog.tscn")
const BLACK_SCREEN = preload("res://Scenes/BlackScreen/BlackScreen.tscn")

const BLACK_POSITION = Vector2(0,-300)

const TEXT1 = "WHAT HAPPEN???"
const TEXT2 = "HELLO RIDER. MY NAME IS CARMACK. YOUR SHIP WAS AMBUSHED BY ME."
const TEXT3 = "WHY DID YOU DO THAT?"
const TEXT4 = "I NEED YOUR SERVICES. YOU ARE THE BEST BOUNTY HUNTER IN THE GALAXY. I NEED TO TAKE SOMETHING CALLED 'THE GEM'."
const TEXT5 = "NEVER HEARD OF."
const TEXT6 = "I HAVE THE INFORMATION THAT YOU NEED. YOU HAVE TO GO TO THE PLANET KONISBERG AND FIND DJIKSTRA. HE KNOW WHERE THE GEM ARE."
const TEXT7 = "DO THIS FOR ME, AND YOU GET A GREAT BOUNTY. I GUARANTEE."
const TEXT8 = "FINE. I ALWAYS DO MY JOB. I WILL FIND DJIKSTRA AND THE GEM"
const TEXT9 = "VERY GOOD..."

var yellow = Color(1,1,0,1)
var red = Color(1, 0, 0, 1)
var green = Color(0,1,0,1)
var blue = Color(0,0,1,1)

var dialog
signal acabou
signal apertou
signal fade

func _ready():
	$PlayerTest/camera.queue_free()
	$PlayerTest.set_physics_process(false)
	begin()
	yield(self, "fade")
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
	cria_dialogo("CARMACK", red, TEXT2)
	yield(self, "acabou")
	$CanvasLayer/Sprite.set_position(BLACK_POSITION)
	begin()
	yield(self, "fade")
	cria_dialogo("RIDER", yellow, TEXT3)
	yield(self, "acabou")
	cria_dialogo("CARMACK", red, TEXT4)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT5)
	yield(self, "acabou")
	cria_dialogo("CARMACK", red, TEXT6)
	yield(self, "acabou")
	cria_dialogo("CARMACK", red, TEXT7)
	yield(self, "acabou")
	cria_dialogo("RIDER", yellow, TEXT8)
	yield(self, "acabou")
	cria_dialogo("CARMACK", red, TEXT9)
	yield(self, "acabou")
	change_level()

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

func change_level():
	end()
	yield(self, "fade")
	get_tree().change_scene(next_world)
