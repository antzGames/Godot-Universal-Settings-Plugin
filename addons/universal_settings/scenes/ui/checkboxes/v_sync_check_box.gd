extends CheckButton

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"mobile":
			# disable window mode and resolutions on phones (Android and iOS)
			if OS.get_name() == "Android" or OS.get_name() == "iOS":
				visible = false

		"gl_compatibility":
			if OS.get_name() == "Web":
				visible = false

func _on_load_settings():
	# Vsync: Not available on Web
	if OS.get_name() != "Web":
		if UniversalSettings.settings_data.vsync == DisplayServer.VSYNC_ENABLED:
			button_pressed = true
		else:
			button_pressed = false
		_on_v_sync_check_box_toggled(button_pressed)

func _on_v_sync_check_box_toggled(toggled_on):
	print(name, " ", toggled_on)
	
	if toggled_on:
		UniversalSettings.settings_data.vsync = DisplayServer.VSYNC_ENABLED
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		UniversalSettings.settings_data.vsync = DisplayServer.VSYNC_DISABLED
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
