extends Panel

var accum = 0

func _process(delta):
    accum += delta
    text = str(accum) # text is a built-in label property

func _on_button_pressed():
	get_node("Label").text = "HELLO!"

func _ready():
	get_node("Button").connect("pressed", self, "_on_button_pressed")
