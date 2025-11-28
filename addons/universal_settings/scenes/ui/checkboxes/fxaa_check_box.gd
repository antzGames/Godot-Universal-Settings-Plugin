extends CheckButton

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	
	# Compatibility mode does not support TAA
	match rendering_method:
		"gl_compatibility":
			visible = false

func _on_load_settings():
	# FXAA: Only available on Mobile and Forward+
	if UniversalSettings.renderer != 0:
		if UniversalSettings.settings_data.fxaa == Viewport.SCREEN_SPACE_AA_FXAA:
			button_pressed = true
		else:
			button_pressed = false
		_on_fxaa_check_box_toggled(button_pressed)


func _on_fxaa_check_box_toggled(toggled_on):
	print(name, " ", toggled_on)
	
	if toggled_on:
		UniversalSettings.settings_data.fxaa = Viewport.SCREEN_SPACE_AA_FXAA
		get_tree().get_root().get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	else:
		UniversalSettings.settings_data.fxaa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_tree().get_root().get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
