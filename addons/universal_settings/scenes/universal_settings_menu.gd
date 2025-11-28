extends ColorRect

# this is the tab container
@onready var tab_container: TabContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var save_button = $CenterContainer/MarginContainer/VBoxContainer/SaveButton
@onready var audio_container: VBoxContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/AudioContainer

var renderer: int # 0 = Compatibility, 1 = Mobile, 2 = Forward+
var current_monitor : int = DisplayServer.window_get_current_screen()

# signals
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

# Keybinds
@onready var input_button_scene = preload("res://addons/universal_settings/scenes/ui/components/input_button.tscn")
@onready var action_list: VBoxContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Keybinds/MarginContainer/ScrollContainer/ActionList
@onready var reset_button: Button = $CenterContainer/MarginContainer/VBoxContainer/ResetButton

var is_remapping = false
var action_to_remap = null
var remapping_button = null

# Keybinds dictionary
# 
# You must map the all the project setting's input map 
# that you want to allow to be remaped in this dictionary.
# You can save up to 10 keybings without modifying the plugin.
# 1st term is the action name in your project setting's input map.
# 2nd term is the name of the action that you want displayed on the settings screen.
# You can only map one keyboard key or one mouse button per action.
# At the moment I do not check for duplicate keybinds.
# 
var input_actions : Dictionary = {
	"universal_forward" : "Move Forward", 	# index 0
	"universal_back" 	: "Move Backward",	# index 1
	"universal_left" 	: "Turn Left",		# index 2
	"universal_right" 	: "Turn Right",		# index 3
	"universal_run" 	: "Run",			# index 4
	"universal_jump" 	: "Jump",			# index 5
	"universal_fire" 	: "Fire",			# index 6
	"universal_interact": "Interact",		# index 7
	"universal_reset" 	: "Reset",			# index 8
	"universal_exit" 	: "Exit"}			# index 9

func _ready():
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
		create_action_list(true)
	else:
		create_action_list(false)
	
	
	
	
	
	
	
	
	
	
func create_action_list(set_defaults: bool):
	for item in action_list.get_children():
		item.queue_free()
		
	var index: int = 0
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		add_key_bind(index, action, set_defaults)
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)").to_upper()
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		index += 1
	
func add_key_bind(index: int, action, set_defaults):
	if !InputMap.action_get_events(action):
		printerr("UniversalSettings Error: Action '", action, "' not found in project config.")
		return

	var key_bind = InputEventKey.new()
	var mouse_bind = InputEventMouseButton.new()
	var is_mouse = false
	
	match index:
		0: # "universal_forward":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_0_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_0_keycode = int(event.button_index)
			elif settings_data.universal_keybind_0_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_0_keycode
			elif settings_data.universal_keybind_0_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_0_keycode
		1: # "universal_back":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_1_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_1_keycode = int(event.button_index)
			elif settings_data.universal_keybind_1_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_1_keycode
			elif settings_data.universal_keybind_1_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_1_keycode
		2: # "universal_left":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_2_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_2_keycode = int(event.button_index)
			elif settings_data.universal_keybind_2_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_2_keycode
			elif settings_data.universal_keybind_2_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_2_keycode
		3: # "universal_right":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_3_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_3_keycode = int(event.button_index)
			elif settings_data.universal_keybind_3_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_3_keycode
			elif settings_data.universal_keybind_3_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_3_keycode
		4: # "universal_run":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_4_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_4_keycode = int(event.button_index)
			elif settings_data.universal_keybind_4_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_4_keycode
			elif settings_data.universal_keybind_4_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_4_keycode
		5: # "universal_jump":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_5_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_5_keycode = int(event.button_index)
			elif settings_data.universal_keybind_5_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_5_keycode
			elif settings_data.universal_keybind_5_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_5_keycode
		6: # "universal_fire":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_6_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_6_keycode = int(event.button_index)
			elif settings_data.universal_keybind_6_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_6_keycode
			elif settings_data.universal_keybind_6_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_6_keycode
		7: # "universal_interact":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_7_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_7_keycode = int(event.button_index)
			elif settings_data.universal_keybind_7_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_7_keycode
			elif settings_data.universal_keybind_7_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_7_keycode
		8: # "universal_reset":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_8_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_8_keycode = int(event.button_index)
			elif settings_data.universal_keybind_8_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_8_keycode
			elif settings_data.universal_keybind_8_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_8_keycode
		9: # "universal_exit":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					settings_data.universal_keybind_9_keycode = int(event.physical_keycode)
				else:
					settings_data.universal_keybind_9_keycode = int(event.button_index)
			elif settings_data.universal_keybind_9_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = settings_data.universal_keybind_9_keycode
			elif settings_data.universal_keybind_9_keycode > 7:
				key_bind.keycode = settings_data.universal_keybind_9_keycode
		_:
			key_bind.keycode = -1
	
	if !set_defaults:
		InputMap.erase_action(action)
		InputMap.add_action(action)
		if is_mouse:
			InputMap.action_add_event(action, mouse_bind)
		else:
			InputMap.action_add_event(action, key_bind)

func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	create_action_list(true)
	
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
	
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)").to_upper()
	
func _input(event: InputEvent):
	if !visible: return

	if is_remapping:
		if (event is InputEventKey || 
		(event is InputEventMouseButton && event.pressed)):
			
			# remove double clicks
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
	
			var key_code
			if event is InputEventKey:
				key_code = event.keycode
			elif event is InputEventMouseButton:
				key_code = event.button_index
			
			var index: int = 0
			for i in input_actions:
				if i == action_to_remap:
					break
				index += 1
			
			match index:
				0: # "move_forward":
					settings_data.universal_keybind_0_keycode = key_code
				1: # "move_back":
					settings_data.universal_keybind_1_keycode = key_code
				2: # "move_left":
					settings_data.universal_keybind_2_keycode = key_code
				3: # "move_right":
					settings_data.universal_keybind_3_keycode = key_code
				4: # "run":
					settings_data.universal_keybind_4_keycode = key_code
				5: # "jump":
					settings_data.universal_keybind_5_keycode = key_code
				6: # "fire":
					settings_data.universal_keybind_6_keycode = key_code
				7: # "interact":
					settings_data.universal_keybind_7_keycode = key_code
				8: # "reset":
					settings_data.universal_keybind_8_keycode = key_code
				9: # "exit":
					settings_data.universal_keybind_9_keycode = key_code
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
	
	
	
	
	
	
func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
	
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
