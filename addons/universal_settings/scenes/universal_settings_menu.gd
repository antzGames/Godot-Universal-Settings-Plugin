extends ColorRect

# this is the tab container
@onready var tab_container: TabContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer

@onready var audio_container: VBoxContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/AudioContainer
@onready var keybind_list: KeyBindList = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Keybinds/MarginContainer/ScrollContainer/KeybindList

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var save_button = $CenterContainer/MarginContainer/VBoxContainer/SaveButton
@onready var reset_button: Button = $CenterContainer/MarginContainer/VBoxContainer/ResetButton

var renderer: int # 0 = Compatibility, 1 = Mobile, 2 = Forward+
var current_monitor : int = DisplayServer.window_get_current_screen()

# signals
signal show_settings_screen
signal on_load_settings 
signal on_initialize_controls
signal on_fsr_mode_changed(int)
signal on_resolution_item_selected(int)


# saving/loading resource
var settings_data : SettingsDataResource
var save_settings_path = "user://game_data/"

# if you change your project version then you will reset your settings, swap to next line if this not needed
var save_file_name = str("settings_data", ProjectSettings.get_setting("application/config/version"), ".tres")
#var save_file_name = str("settings_data.tres") # always use same settings file on all versions of your game

#region DICTIONARIES for options dropdowns

# window mode dictionary - Exclusive FullScreen has to be the first element and must exist
@export var window_modes : Dictionary = {
	"Fullscreen" : DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, # this has to be first and must exist
	"Window" : DisplayServer.WINDOW_MODE_WINDOWED}

# You can modify these window resolutions to your liking, 
# but there must to be at least ONE entry.
# Make sure your default resolution is set in the settings_data_resource.gd file
@export var resolutions : Dictionary = {"1280x720"  :  Vector2i(1280, 720),  # index 0
										"1440x810"  :  Vector2i(1440, 810),  # index 1
										"1600x900"  :  Vector2i(1600, 900),  # index 2
										"1920x1080" :  Vector2i(1920, 1080)} # index 3

# MSAA:
# Make sure you default MSAA mode is set in the seetings_data_resource.gd file
var msaa_modes : Dictionary =  {"None": Viewport.MSAA_DISABLED, 		# index/value = 0
										"2x" : Viewport.MSAA_2X,		# index/value = 1
										"4x" : Viewport.MSAA_4X,		# index/value = 2
										"8x" : Viewport.MSAA_8X}		# index/value = 3

# Make sure you default frs_mode is set in the seetings_data_resource.gd file
var fsr_modes : Dictionary =  { "Bilinear": Viewport.SCALING_3D_MODE_BILINEAR, 	# index/value = 0
								"FSR 1.0": Viewport.SCALING_3D_MODE_FSR,		# index/value = 1
								"FSR 2.2": Viewport.SCALING_3D_MODE_FSR2}		# index/value = 2
#endregion

func _ready():
	show_settings_screen.connect(show_screen)
	load_settings_from_storage()
	
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"forward_plus":
			renderer = 2  # Forward+
		"mobile":
			renderer = 1  # Mobile
		"gl_compatibility":
			renderer = 0  # Compatibility / Web
	
	visible = false
	save_button.pressed.connect(quit_menu)

	load_settings()
	initialize_controls()
	
	if settings_data == null || settings_data.universal_keybind_0_keycode == 0: # if first time running game
		keybind_list.create_action_list(true)
	else:
		keybind_list.create_action_list(false)
	
func initialize_controls():
	on_initialize_controls.emit()
	
func _process(_delta: float) -> void:
	if !visible: return
	
	if tab_container.current_tab == 2:
		reset_button.visible = true
	else:
		reset_button.visible = false

func save_settings():
	audio_container.save_volumes_levels()
	save_settings_resources()

func load_settings():
	if settings_data != null:
		on_load_settings.emit()

func quit_menu():
	save_settings()
	animation_player.play("HideSettings")

func show_screen():
	if visible: return
	tab_container.current_tab = 0
	animation_player.play("ShowSettings")
	
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass
	# the following with grab the focus of the SAVE button if a controller is connected
	#if Input.get_connected_joypads() and Input.get_connected_joypads().size() > 0:
		#save_button.call_deferred("grab_focus")

func get_settings_init() -> SettingsDataResource:
	return settings_data

func load_settings_from_storage():
	if !DirAccess.dir_exists_absolute(save_settings_path):
		DirAccess.make_dir_absolute(save_settings_path)

	if ResourceLoader.exists(save_settings_path + save_file_name):
		settings_data = ResourceLoader.load(save_settings_path + save_file_name)

	if settings_data == null:
		settings_data = SettingsDataResource.new()

# this saves settings to storage
func save_settings_resources():
	ResourceSaver.save(settings_data, save_settings_path + save_file_name)

# You can swap themes bu passing the path to the theme .tres file, 
# and set the tab container size if you nee more space, 
# and you can set a self modulate color for the tab container.
func set_theme_to(theme_path: String, tab_container_size: Vector2 = tab_container.custom_minimum_size, tab_color: Color = Color.WHITE):
	theme = load(theme_path)
	tab_container.custom_minimum_size = tab_container_size
	tab_container.self_modulate = tab_color

func _on_reset_button_pressed() -> void:
	keybind_list._on_reset_button_pressed()
