extends CanvasLayer

var timer = 0.0
var value

# Função quando é iniciado o objeto
func _ready():
	set_process(true)
	$DashBar.set_value(0)

# Função que roda a cada frame
func _process(delta):
	value = $DashBar.get_value()
	if value != 100:
		$DashBar.set_value(value + delta*100)

# Função que indica que a barra está completa
func is_complete():
	value = $DashBar.get_value()
	if value == 100:
		return true;
	return false;

# Função para indicar que o dash foi usado
func usou_dash():
	$DashBar.set_value(0)