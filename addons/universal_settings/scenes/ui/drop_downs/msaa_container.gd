extends HBoxContainer

var msaa_mode_selected: int
@onready var msaa_option: OptionButton = $MSAAOptionButton

func _ready() -> void:
	UniversalSettings.on_load_settings.connect(_on_load_settings)
	UniversalSettings.on_initialize_controls.connect(_on_initialize_controls)


func _on_initialize_controls():
	msaa_option.selected = UniversalSettings.settings_data.msaa_3d_index

	
func _on_load_settings():
	set_msaa(UniversalSettings.settings_data.msaa_3d, UniversalSettings.settings_data.msaa_3d_index)


func _on_msaa_option_button_item_selected(index):
	msaa_mode_selected = UniversalSettings.msaa_modes.get(msaa_option.get_item_text(index)) as int
	set_msaa(msaa_mode_selected, index)


func set_msaa(mode: int, index: int):
	#print("MSAA: ", mode, " ", index)
	match mode:
		Viewport.MSAA_DISABLED:
			get_tree().get_root().msaa_3d = Viewport.MSAA_DISABLED
		Viewport.MSAA_2X:
			get_tree().get_root().msaa_3d = Viewport.MSAA_2X
		Viewport.MSAA_4X:
			get_tree().get_root().msaa_3d = Viewport.MSAA_4X
		Viewport.MSAA_8X:
			get_tree().get_root().msaa_3d = Viewport.MSAA_8X
		_:
			get_tree().get_root().msaa_3d = Viewport.MSAA_4X
			
	UniversalSettings.settings_data.msaa_3d = mode
	UniversalSettings.settings_data.msaa_3d_index = index
