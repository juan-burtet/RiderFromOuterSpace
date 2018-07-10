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
	$Upgrades/qt.set_text(str(global.get_upgrades()))
	$Coins/qt.set_text(str(global.get_coins()))
	
	update_hp()
	update_label()
	pass

func update_label():
	match global.get_heart():
		0:
			$Hearts/Label.set_size(Vector2(54,8))
		1:
			$Hearts/Label.set_size(Vector2(64,8))
		2:
			$Hearts/Label.set_size(Vector2(80,8))
		3:
			$Hearts/Label.set_size(Vector2(96,8))
	pass

func update_hp():
	var x = global.get_heart()
	match x:
		1:
			$Hearts/'4'.set_visible(true)
			pass
		2:
			$Hearts/'4'.set_visible(true)
			$Hearts/'5'.set_visible(true)
			pass
		3:
			$Hearts/'4'.set_visible(true)
			$Hearts/'5'.set_visible(true)
			$Hearts/'6'.set_visible(true)
			pass

# Função que indica que a barra está completa
func is_complete():
	value = $DashBar.get_value()
	if value == 100:
		return true;
	return false;

# Função para indicar que o dash foi usado
func usou_dash():
	$DashBar.set_value(0)