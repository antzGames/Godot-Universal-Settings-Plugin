extends HBoxContainer

@onready var window_mode_option: OptionButton = $WindowModeButton
@onready var universal_settings_menu: ColorRect = $"../../../../../../.."
var window_mode_selected

func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	universal_settings_menu.on_initialize_controls.connect(_on_initialize_controls)

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
		window_mode_option.selected = universal_settings_menu.settings_data.window_mode_index
	
func _on_load_settings():
		# No windows or resolution on Web
		if OS.get_name() != "Web":
			for window_mode in universal_settings_menu.window_modes:
				window_mode_option.add_item(window_mode)
			
			_on_window_mode_button_item_selected(universal_settings_menu.settings_data.window_mode_index)

func _on_window_mode_button_item_selected(index):
	window_mode_selected = universal_settings_menu.window_modes.get(window_mode_option.get_item_text(index)) as int
	set_window_mode(window_mode_selected, index)

func set_window_mode(window_mode : int, window_mode_index: int):
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			universal_settings_menu.settings_data.window_mode_index = window_mode_index
			universal_settings_menu.on_resolution_item_selected.emit(universal_settings_menu.settings_data.resolution_index)
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	universal_settings_menu.settings_data.window_mode = window_mode
	universal_settings_menu.settings_data.window_mode_index = window_mode_index
