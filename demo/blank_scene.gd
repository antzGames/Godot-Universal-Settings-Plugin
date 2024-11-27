extends Node3D

func _ready() -> void:
	UniversalSettings.show_screen()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"): 
		UniversalSettings.show_screen()  # will do nothing if already visible
	
	
