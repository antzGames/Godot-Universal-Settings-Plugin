extends ColorRect

# this is the tab container
@onready var tab_container: TabContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var save_button = $CenterContainer/MarginContainer/VBoxContainer/SaveButton

# Options dropdowns
@onready var screen_option_button: OptionButton = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/MonitorContainer/MonitorButton"
@onready var window_mode_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/WindowModeContainer/WindowModeButton"
@onready var resolution_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/ResolutionContainer/ResolutionOptionButton"
@onready var msaa_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/MSAAContainer/MSAAOptionButton"
@onready var fsr_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/FSRContainer/FSROptionButton"

# Check boxes
@onready var fxaa_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/FXAACheckBox"
@onready var taa_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/TAACheckBox"
@onready var vysnc_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/VSyncCheckBox"
@onready var scale_3d_slider = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/3DScaleContainer/3DScaleSlider"

# 3D Scale slider label
@onready var scale_3d_label = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/3DScaleContainer/Scale3DLabel"

# Audio
@onready var master_volume: VolumeSlider = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/VBoxContainer/MasterSlider
@onready var music_volume: VolumeSlider = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/VBoxContainer/MusicSlider
@onready var sfx_volume: VolumeSlider = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/VBoxContainer/SFXSlider
@onready var voice_volume: VolumeSlider = $CenterContainer/MarginContainer/VBoxContainer/TabContainer/Audio/VBoxContainer/VoiceSlider

# what is selected from drop downs
var window_mode_selected
var resolution_mode_selected
var msaa_mode_selected
var fsr_mode_selected

var renderer: int # 0 = Compatibility, 1 = Mobile, 2 = Forward+
var last_monitor_count := DisplayServer.get_screen_count() # monitor count

# saving/loading resource
var settings_data : SettingsDataResource
var save_settings_path = "user://game_data/"
var save_file_name = str("settings_data", ProjectSettings.get_setting("application/config/version"), ".tres")

# dictionaries for options dropdowns

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

# Keybinds
@onready var input_button_scene = preload("res://addons/universal_settings/scenes/ui/input_button.tscn")
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

func _init() -> void:
	pass

func _ready():
	load_settings_from_storage()
	
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"forward_plus":
			renderer = 2  # Forward+ = desktop
		"mobile":
			renderer = 1 
			fsr_option.disabled = true
			taa_checkbox.visible = false
			
			# disable window mode and resolutions on phones (Android and iOS)
			if OS.get_name() == "Android" or OS.get_name() == "iOS":
				resolution_option.disabled = true
				window_mode_option.disabled = true
				vysnc_checkbox.visible = false

		"gl_compatibility":
			renderer = 0
			fsr_option.disabled = true
			taa_checkbox.visible = false
			fxaa_checkbox.visible = false

			if OS.get_name() == "Web":
				vysnc_checkbox.visible = false
				resolution_option.disabled = true
				window_mode_option.disabled = true
				screen_option_button.disabled = true
				
	visible = false
	save_button.pressed.connect(quit_menu)
	scale_3d_slider.value_changed.connect(_on_scale_3D_value_changed)

	if OS.get_name() != "Web":
		set_monitor_options()
	
	if renderer != 2:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	else:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR

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
	if OS.get_name() != "Web":
		window_mode_option.selected = settings_data.window_mode_index
		resolution_option.selected = settings_data.resolution_index
	
	if renderer == 2:
		fsr_option.selected = settings_data.fsr_mode_index
	
	msaa_option.selected = settings_data.msaa_3d_index
	
func _process(_delta: float) -> void:
	if !visible: return
	
	if tab_container.current_tab == 2:
		reset_button.visible = true
	else:
		reset_button.visible = false
	
	if OS.get_name() != "Web":
		if DisplayServer.get_screen_count() != last_monitor_count:
			set_monitor_options()
		last_monitor_count = DisplayServer.get_screen_count()
		
		if settings_data.window_mode != 4:
			resolution_option.disabled = false
		else:
			resolution_option.disabled = true
	
	if renderer == 2:
		if fsr_option.selected == 2:
			taa_checkbox.disabled = true
		else:
			taa_checkbox.disabled = false

func save_settings():
	settings_data.master_volume = master_volume.slider.value
	settings_data.sfx_volume = sfx_volume.slider.value
	settings_data.music_volume = music_volume.slider.value
	settings_data.voice_volume = voice_volume.slider.value
	save_settings_resources()

func load_settings():
	if settings_data != null:
		# Volumes
		master_volume.slider.value = settings_data.master_volume
		sfx_volume.slider.value = settings_data.sfx_volume
		music_volume.slider.value = settings_data.music_volume
		voice_volume.slider.value = settings_data.voice_volume

		# No windows or resolution on Web
		if OS.get_name() != "Web":
			for window_mode in window_modes:
				window_mode_option.add_item(window_mode)
			for resolution in resolutions:
				resolution_option.add_item(resolution)
			
			#set_window_mode(settings_data.window_mode, settings_data.window_mode_index)
			_on_window_mode_button_item_selected(settings_data.window_mode_index)
			#set_resolution(settings_data.resolution, settings_data.resolution_index)
			_on_resolution_option_button_item_selected(settings_data.resolution_index)
		
		# FSR: only available on Forward+
		if renderer == 2:
			set_fsr(settings_data.fsr_mode, settings_data.fsr_mode_index)
			
		# MSAA
		set_msaa(settings_data.msaa_3d, settings_data.msaa_3d_index)
		
		# 3D Scale
		_on_scale_3D_value_changed(settings_data.scale_3d)

		# FXAA: Only available on Mobile and Forward+
		if renderer != 0:
			if settings_data.fxaa == Viewport.SCREEN_SPACE_AA_FXAA:
				fxaa_checkbox.button_pressed = true
			else:
				fxaa_checkbox.button_pressed = false
			_on_fxaa_check_box_toggled(fxaa_checkbox.button_pressed)

		# TAA: Only available on Forward+
		if renderer == 2:
			if settings_data.taa:
				taa_checkbox.button_pressed = true
			else:
				taa_checkbox.button_pressed = false
			_on_taa_check_box_toggled(taa_checkbox.button_pressed)

		# Vsync: Not available on Web
		if OS.get_name() != "Web":
			if settings_data.vsync == DisplayServer.VSYNC_ENABLED:
				vysnc_checkbox.button_pressed = true
			else:
				vysnc_checkbox.button_pressed = false
			_on_v_sync_check_box_toggled(vysnc_checkbox.button_pressed)
		
func set_fsr(mode: int, index: int):
	match mode:
		Viewport.SCALING_3D_MODE_BILINEAR:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		Viewport.SCALING_3D_MODE_FSR:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		Viewport.SCALING_3D_MODE_FSR2:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
		_:
			get_tree().get_root().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
	
	settings_data.fsr_mode = mode
	settings_data.fsr_mode_index = index

func set_msaa(mode: int, index: int):
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
			
	settings_data.msaa_3d = mode
	settings_data.msaa_3d_index = index

func set_resolution(resolution: Vector2i, resolution_index : int):
	settings_data.resolution = resolution
	settings_data.resolution_index = resolution_index
	
	DisplayServer.window_set_size(resolution)
	DisplayServer.window_set_position(DisplayServer.screen_get_size(0)*0.5 - resolution*0.5)

func set_window_mode(window_mode : int, window_mode_index: int):
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			settings_data.window_mode_index = window_mode_index
			_on_resolution_option_button_item_selected(settings_data.resolution_index)
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	settings_data.window_mode = window_mode
	settings_data.window_mode_index = window_mode_index
	
func quit_menu():
	save_settings()
	animation_player.play("HideSettings")

func show_screen():
	if visible: return
	tab_container.current_tab = 0
	animation_player.play("ShowSettings")
	
func _on_monitor_button_item_selected(index: int) -> void:
	DisplayServer.window_set_current_screen(index)

func set_monitor_options() -> void:
	screen_option_button.clear()
	
	var monitor_count = DisplayServer.get_screen_count()
	var select_i = 0
	for i in range(monitor_count):
		var is_current := ""
		if i == DisplayServer.window_get_current_screen():
			is_current = " (Current)"
			select_i = i
		screen_option_button.add_item("Monitor %s%s" % [i,is_current])
	
	screen_option_button.select(select_i)
	
func _on_window_mode_button_item_selected(index):
	window_mode_selected = window_modes.get(window_mode_option.get_item_text(index)) as int
	set_window_mode(window_mode_selected, index)

func _on_resolution_option_button_item_selected(index):
	resolution_mode_selected = resolutions.get(resolution_option.get_item_text(index)) as Vector2i
	set_resolution(resolution_mode_selected, index)

func _on_msaa_option_button_item_selected(index):
	msaa_mode_selected = msaa_modes.get(msaa_option.get_item_text(index)) as int
	set_msaa(msaa_mode_selected, index)

func _on_fsr_option_button_item_selected(index):
	fsr_mode_selected = fsr_modes.get(fsr_option.get_item_text(index)) as int
	set_fsr(fsr_mode_selected, index)

func _on_fxaa_check_box_toggled(toggled_on):
	if toggled_on:
		settings_data.fxaa = Viewport.SCREEN_SPACE_AA_FXAA
		get_tree().get_root().get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	else:
		settings_data.fxaa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_tree().get_root().get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

func _on_taa_check_box_toggled(toggled_on):
	if toggled_on:
		settings_data.taa = true
		if OS.get_name() != "Web":
			get_tree().get_root().get_viewport().use_taa = true
	else:
		settings_data.taa = false
		if OS.get_name() != "Web":
			get_tree().get_root().get_viewport().use_taa = false

func _on_v_sync_check_box_toggled(toggled_on):
	if toggled_on:
		settings_data.vsync = DisplayServer.VSYNC_ENABLED
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		settings_data.vsync = DisplayServer.VSYNC_DISABLED
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
func _on_scale_3D_value_changed(v : int):
	var value : float
	if v == 4:
		scale_3d_label.text = str("100%")
		settings_data.scale_3d = 4
		value = 1.0
	elif v == 3:
		scale_3d_label.text = str("77%")
		settings_data.scale_3d = 3
		value = 0.77
	elif v == 2:
		scale_3d_label.text = str("67%")
		settings_data.scale_3d = 2
		value = 0.67
	elif v == 1:
		scale_3d_label.text = str("59%")
		settings_data.scale_3d = 1
		value = 0.59
	elif v == 0:
		scale_3d_label.text = str("50%")
		settings_data.scale_3d = 0
		value = 0.5
	else:
		scale_3d_label.text = str("100%")
		settings_data.scale_3d = 4
		value = 1.0

	scale_3d_slider.value = v
	get_viewport().scaling_3d_scale = value

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
