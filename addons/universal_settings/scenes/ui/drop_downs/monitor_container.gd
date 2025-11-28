extends HBoxContainer

@onready var monitor_option_button: OptionButton = $MonitorButton
@onready var universal_settings_menu: ColorRect = $"../../../../../../.."

var last_monitor_count := DisplayServer.get_screen_count() # monitor count


func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	universal_settings_menu.on_initialize_controls.connect(_on_initialize_controls)

	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"gl_compatibility":
			if OS.get_name() == "Web":
				monitor_option_button.disabled = true
				
	if OS.get_name() != "Web":
		set_monitor_options()

func _process(delta: float) -> void:
	if OS.get_name() != "Web":
		if DisplayServer.get_screen_count() != last_monitor_count:
			set_monitor_options()
		last_monitor_count = DisplayServer.get_screen_count()

func _on_initialize_controls():
	pass
	
func _on_load_settings():
	pass

func set_monitor_options() -> void:
	#print("Monitor options set")
	monitor_option_button.clear()
	
	var monitor_count = DisplayServer.get_screen_count()
	var select_i = 0
	for i in range(monitor_count):
		var is_current := ""
		if i == DisplayServer.window_get_current_screen():
			is_current = " (Current)"
			select_i = i
			universal_settings_menu.current_monitor = i
		monitor_option_button.add_item("Monitor %s%s" % [i,is_current])
	
	monitor_option_button.select(select_i)
	


func _on_monitor_button_item_selected(index: int) -> void:
	DisplayServer.window_set_position(Vector2i.ZERO)
	DisplayServer.window_set_current_screen(index)
	universal_settings_menu.current_monitor = index
