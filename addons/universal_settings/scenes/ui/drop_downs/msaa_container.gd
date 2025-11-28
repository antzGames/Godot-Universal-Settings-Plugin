extends HBoxContainer

var msaa_mode_selected: int
@onready var msaa_option: OptionButton = $MSAAOptionButton
@onready var universal_settings_menu: ColorRect = $"../../../../../../.."

func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	universal_settings_menu.on_initialize_controls.connect(_on_initialize_controls)


func _on_initialize_controls():
	msaa_option.selected = universal_settings_menu.settings_data.msaa_3d_index

	
func _on_load_settings():
	set_msaa(universal_settings_menu.settings_data.msaa_3d, universal_settings_menu.settings_data.msaa_3d_index)


func _on_msaa_option_button_item_selected(index):
	msaa_mode_selected = universal_settings_menu.msaa_modes.get(msaa_option.get_item_text(index)) as int
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
			
	universal_settings_menu.settings_data.msaa_3d = mode
	universal_settings_menu.settings_data.msaa_3d_index = index
