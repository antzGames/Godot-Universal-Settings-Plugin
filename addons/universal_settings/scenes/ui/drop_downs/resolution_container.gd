extends HBoxContainer

@onready var resolution_option: OptionButton = $ResolutionOptionButton
@onready var universal_settings_menu: ColorRect = $"../../../../../../.."

var resolution_mode_selected: Vector2i

func _ready() -> void:
	universal_settings_menu.on_load_settings.connect(_on_load_settings)
	universal_settings_menu.on_initialize_controls.connect(_on_initialize_controls)
	universal_settings_menu.on_resolution_item_selected.connect(_on_resolution_option_button_item_selected)

	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"mobile":
			# disable window mode and resolutions on phones (Android and iOS)
			if OS.get_name() == "Android" or OS.get_name() == "iOS":
				resolution_option.disabled = true
		"gl_compatibility":
			if OS.get_name() == "Web":
				resolution_option.disabled = true


func _process(_delta: float) -> void:
	if OS.get_name() != "Web":
		if universal_settings_menu.settings_data.window_mode != 4:
			resolution_option.disabled = false
		else:
			resolution_option.disabled = true

func _on_initialize_controls():
	if OS.get_name() != "Web":
		resolution_option.selected = universal_settings_menu.settings_data.resolution_index

	
func _on_load_settings():
		# No windows or resolution on Web
		if OS.get_name() != "Web":
			for resolution in universal_settings_menu.resolutions:
				resolution_option.add_item(resolution)
				#print(resolution)
			_on_resolution_option_button_item_selected(universal_settings_menu.settings_data.resolution_index)


func _on_resolution_option_button_item_selected(index):
	if resolution_option.item_count == 0: return

	resolution_mode_selected = universal_settings_menu.resolutions.get(resolution_option.get_item_text(index)) as Vector2i
	set_resolution(resolution_mode_selected, index)

func set_resolution(resolution: Vector2i, resolution_index : int):
	universal_settings_menu.settings_data.resolution = resolution
	universal_settings_menu.settings_data.resolution_index = resolution_index
	
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_position(DisplayServer.screen_get_size()*0.5 - resolution*0.5)
	DisplayServer.window_set_current_screen(universal_settings_menu.current_monitor)
