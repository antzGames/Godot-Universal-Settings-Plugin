extends HBoxContainer

@onready var fsr_option: OptionButton = $FSROptionButton
@onready var universal_settings_menu: ColorRect = $"../../../../../../.."

var fsr_mode_selected: int

func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	universal_settings_menu.on_initialize_controls.connect(_on_initialize_controls)

	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"mobile":
			fsr_option.disabled = true
		"gl_compatibility":
			fsr_option.disabled = true


func _on_initialize_controls():
	if universal_settings_menu.renderer == 2:
		fsr_option.selected = universal_settings_menu.settings_data.fsr_mode_index

func _on_load_settings():
	# FSR: only available on Forward+
	if universal_settings_menu.renderer == 2:
		set_fsr(universal_settings_menu.settings_data.fsr_mode, universal_settings_menu.settings_data.fsr_mode_index)


func _on_fsr_option_button_item_selected(index):
	fsr_mode_selected = universal_settings_menu.fsr_modes.get(fsr_option.get_item_text(index)) as int
	set_fsr(fsr_mode_selected, index)

func set_fsr(mode: int, index: int):
	match mode:
		Viewport.SCALING_3D_MODE_BILINEAR:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		Viewport.SCALING_3D_MODE_FSR:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		Viewport.SCALING_3D_MODE_FSR2:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
		_:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	
	universal_settings_menu.settings_data.fsr_mode = mode
	universal_settings_menu.settings_data.fsr_mode_index = index
	universal_settings_menu.on_fsr_mode_changed.emit(index)
