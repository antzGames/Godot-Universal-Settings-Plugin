extends HBoxContainer

@onready var window_mode_option: OptionButton = $WindowModeButton
var window_mode_selected

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	UniversalSettings.on_initialize_controls.connect(_on_initialize_controls)

	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"mobile":
			# disable window mode and resolutions on phones (Android and iOS)
			if OS.get_name() == "Android" or OS.get_name() == "iOS":
				window_mode_option.disabled = true
		"gl_compatibility":
			if OS.get_name() == "Web":
				window_mode_option.disabled = true

func _on_initialize_controls():
	if OS.get_name() != "Web":
		window_mode_option.selected = UniversalSettings.settings_data.window_mode_index
	
func _on_load_settings():
		# No windows or resolution on Web
		if OS.get_name() != "Web":
			for window_mode in UniversalSettings.window_modes:
				window_mode_option.add_item(window_mode)
			
			_on_window_mode_button_item_selected(UniversalSettings.settings_data.window_mode_index)

func _on_window_mode_button_item_selected(index):
	window_mode_selected = UniversalSettings.window_modes.get(window_mode_option.get_item_text(index)) as int
	set_window_mode(window_mode_selected, index)

func set_window_mode(window_mode : int, window_mode_index: int):
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			UniversalSettings.settings_data.window_mode_index = window_mode_index
			UniversalSettings.on_resolution_item_selected.emit(UniversalSettings.settings_data.resolution_index)
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	UniversalSettings.settings_data.window_mode = window_mode
	UniversalSettings.settings_data.window_mode_index = window_mode_index
