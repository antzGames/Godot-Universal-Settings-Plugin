extends CheckButton

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	UniversalSettings.on_fsr_mode_changed.connect(_on_fsr_mode_changed)
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))

	match rendering_method:
		"mobile":
			visible = false
		"gl_compatibility":
			visible = false

func _on_fsr_mode_changed(selected: int):
	print("FSR mode selected: ", selected)
	
	if UniversalSettings.renderer == 2:
		if selected == 2:
			disabled = true
		else:
			disabled = false

func _on_load_settings():
	# TAA: Only available on Forward+
	if UniversalSettings.renderer == 2:
		if UniversalSettings.settings_data.taa:
			button_pressed = true
		else:
			button_pressed = false
		_on_taa_check_box_toggled(button_pressed)


func _on_taa_check_box_toggled(toggled_on):
	print(name, " ", toggled_on)
	
	if toggled_on:
		UniversalSettings.settings_data.taa = true
		if OS.get_name() != "Web":
			get_tree().get_root().get_viewport().use_taa = true
	else:
		UniversalSettings.settings_data.taa = false
		if OS.get_name() != "Web":
			get_tree().get_root().get_viewport().use_taa = false
