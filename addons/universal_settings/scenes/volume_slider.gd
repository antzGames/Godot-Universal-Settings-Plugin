extends HBoxContainer
class_name VolumeSlider

@export var bus_name: String
@onready var slider = $Slider
var bus_index: int
var percent: float

func _ready():
	if AudioServer.get_bus_index((bus_name)) == -1:
		visible = false
		print("Audio bus named: '", bus_name, "' not found. Disabling this named audio bus.")
		return
		
	bus_index = AudioServer.get_bus_index((bus_name))
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	percent = slider.value * 100.0
	$Label.text = str(bus_name, " Volume:")
	$Percent.text = str(percent, "%")
	
func _on_value_changed(v : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(v))
	percent = slider.value * 100.0
	$Percent.text = str(percent as int, "%")
