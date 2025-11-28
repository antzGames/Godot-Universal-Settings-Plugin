class_name VolumeSlider
extends HBoxContainer

@onready var label: Label = $Label
@onready var vol_slider: HSlider = $VolSlider
@onready var percent_label: Label = $PercentLabel

var bus_index: int
var percent: float
var bus_name: String

func _on_value_changed(v : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(v))
	percent = vol_slider.value * 100.0
	percent_label.text = str(percent as int, "%")
