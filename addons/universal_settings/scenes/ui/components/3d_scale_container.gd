extends HBoxContainer

@onready var scale_3d_slider: HSlider = $"3DScaleSlider"
@onready var scale_3d_label: Label = $Scale3DLabel

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	scale_3d_slider.value_changed.connect(_on_scale_3D_value_changed)

	var renderer: int = 0
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	
	match rendering_method:
		"forward_plus":
			renderer = 2  # Forward+ = desktop
		"mobile":
			renderer = 1 
		"gl_compatibility":
			renderer = 0

	if renderer != 2:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	else:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR

func _on_load_settings():
	_on_scale_3D_value_changed(UniversalSettings.settings_data.scale_3d)

func _on_scale_3D_value_changed(v : int):
	print(name, " ", v)
	
	var value : float
	if v == 4:
		scale_3d_label.text = str("100%")
		UniversalSettings.settings_data.scale_3d = 4
		value = 1.0
	elif v == 3:
		scale_3d_label.text = str("77%")
		UniversalSettings.settings_data.scale_3d = 3
		value = 0.77
	elif v == 2:
		scale_3d_label.text = str("67%")
		UniversalSettings.settings_data.scale_3d = 2
		value = 0.67
	elif v == 1:
		scale_3d_label.text = str("59%")
		UniversalSettings.settings_data.scale_3d = 1
		value = 0.59
	elif v == 0:
		scale_3d_label.text = str("50%")
		UniversalSettings.settings_data.scale_3d = 0
		value = 0.5
	else:
		scale_3d_label.text = str("100%")
		UniversalSettings.settings_data.scale_3d = 4
		value = 1.0

	scale_3d_slider.value = v
	get_viewport().scaling_3d_scale = value
