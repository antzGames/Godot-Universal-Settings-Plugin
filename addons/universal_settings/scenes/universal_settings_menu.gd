extends ColorRect

@onready var tab_container: TabContainer = $CenterContainer/MarginContainer/VBoxContainer/TabContainer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var quit_button = $CenterContainer/MarginContainer/VBoxContainer/SaveButton

# Options dropdowns
@onready var screen_option_button: OptionButton = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/MonitorContainer/MonitorButton"
@onready var window_mode_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/WindowModeContainer/WindowModeButton"
@onready var resolution_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/ResolutionContainer/ResolutionOptionButton"
@onready var msaa_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/MSAAContainer/MSAAOptionButton"
@onready var fsr_option = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/FSRContainer/FSROptionButton"

# check boxes
@onready var fxaa_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/FXAACheckBox"
@onready var taa_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/TAACheckBox"
@onready var vysnc_checkbox = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/AAContainer/VSyncCheckBox"
@onready var scale_3d_slider = $"CenterContainer/MarginContainer/VBoxContainer/TabContainer/Graphics/VBoxContainer/3DScaleContainer/3DScaleSlider"

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

var renderer: int # 0 = Compatibility, 1 = Forward Mobile, 2 = Forward+
var last_monitor_count := DisplayServer.get_screen_count() # monitor count

# saving/loading resource
var settings_data : SettingsDataResource
var save_settings_path = "user://game_data/"
var save_file_name = str("settings_data", ProjectSettings.get_setting("application/config/version"), ".tres")

func _init() -> void:
	pass

func _ready():
	load_settings_from_storage()

	#tab_container.get_tab_bar().focus_mode = Control.FOCUS_NONE
	
	var rendering_method := str(ProjectSettings.get_setting_with_override("rendering/renderer/rendering_method"))
	match rendering_method:
		"forward_plus":
			renderer = 2  # Forward+ = desktop
		"mobile":
			renderer = 1 
			resolution_option.disabled = true
			window_mode_option.disabled = true
			fsr_option.disabled = true
			
			vysnc_checkbox.visible = false
			taa_checkbox.visible = false
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
	quit_button.pressed.connect(quit_menu)
	scale_3d_slider.value_changed.connect(_on_scale_3D_value_changed)

	if OS.get_name() != "Web":
		set_monitor_options()
	
	if renderer != 2:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
	else:
		get_tree().get_root().get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR

	load_settings()
	initialize_controls()
	
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
	
	if OS.get_name() != "Web":
		if DisplayServer.get_screen_count() != last_monitor_count:
			set_monitor_options()
		last_monitor_count = DisplayServer.get_screen_count()
		
		if renderer != 1: # cannot change resolution on mobile devices?
			if window_mode_option.selected == 0:
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
			for window_mode in settings_data.window_modes:
				window_mode_option.add_item(window_mode)
			for resolution in settings_data.resolutions:
				resolution_option.add_item(resolution)
			
			set_window_mode(settings_data.window_mode, settings_data.window_mode_index)
			_on_window_mode_button_item_selected(settings_data.window_mode_index)
			set_resolution(settings_data.resolution, settings_data.resolution_index)
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
	
	if settings_data.window_mode_index == 0:
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
	window_mode_selected = settings_data.window_modes.get(window_mode_option.get_item_text(index)) as int
	set_window_mode(window_mode_selected, index)

func _on_resolution_option_button_item_selected(index):
	resolution_mode_selected = settings_data.resolutions.get(resolution_option.get_item_text(index)) as Vector2i
	set_resolution(resolution_mode_selected, index)

func _on_msaa_option_button_item_selected(index):
	msaa_mode_selected = settings_data.msaa_modes.get(msaa_option.get_item_text(index)) as int
	set_msaa(msaa_mode_selected, index)

func _on_fsr_option_button_item_selected(index):
	fsr_mode_selected = settings_data.fsr_modes.get(fsr_option.get_item_text(index)) as int
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
	# the following with grab the focus of the SAVE button if a controller is connected
	if Input.get_connected_joypads() and Input.get_connected_joypads().size() > 0:
		quit_button.call_deferred("grab_focus")

func _input(event: InputEvent):
	if !visible: return
	# you can use this method to catch events specifically for the settings menu if visible

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
