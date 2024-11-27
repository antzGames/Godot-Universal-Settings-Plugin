extends Node3D

func _ready() -> void:
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	UniversalSettings.show_menu()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"): 
		UniversalSettings.show_menu()  # will do nothing if already visible
	
	
