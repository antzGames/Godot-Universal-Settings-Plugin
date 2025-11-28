class_name KeyBindList
extends VBoxContainer

@onready var input_button_scene = preload("res://addons/universal_settings/scenes/ui/components/input_button.tscn")
@onready var keybinds_config = preload("uid://cxprmvpa272kd").instantiate()
@onready var universal_settings_menu: ColorRect = $"../../../../../../../.."

var is_remapping = false
var action_to_remap = null
var remapping_button = null
var input_actions : Dictionary = {}
	
func create_action_list(set_defaults: bool):
	for item in get_tree().get_nodes_in_group("keybind_ui_button"):
		item.queue_free()
	
	build_input_action_dictionary()
	
	var index: int = 0
	for action in input_actions:
		var button = input_button_scene.instantiate()
		button.add_to_group("keybind_ui_button")
		
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		add_key_bind(index, action, set_defaults)
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)").to_upper()
		else:
			input_label.text = ""
			
		add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		index += 1
	
func add_key_bind(index: int, action, set_defaults):
	if !InputMap.action_get_events(action):
		printerr("universal_settings_menu Error: Action '", action, "' not found in project config.")
		return

	var key_bind = InputEventKey.new()
	var mouse_bind = InputEventMouseButton.new()
	var is_mouse = false
	
	match index:
		0: # "universal_forward":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_0_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_0_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_0_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_0_keycode
			elif universal_settings_menu.settings_data.universal_keybind_0_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_0_keycode
		1: # "universal_back":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_1_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_1_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_1_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_1_keycode
			elif universal_settings_menu.settings_data.universal_keybind_1_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_1_keycode
		2: # "universal_left":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_2_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_2_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_2_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_2_keycode
			elif universal_settings_menu.settings_data.universal_keybind_2_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_2_keycode
		3: # "universal_right":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_3_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_3_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_3_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_3_keycode
			elif universal_settings_menu.settings_data.universal_keybind_3_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_3_keycode
		4: # "universal_run":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_4_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_4_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_4_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_4_keycode
			elif universal_settings_menu.settings_data.universal_keybind_4_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_4_keycode
		5: # "universal_jump":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_5_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_5_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_5_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_5_keycode
			elif universal_settings_menu.settings_data.universal_keybind_5_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_5_keycode
		6: # "universal_fire":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_6_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_6_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_6_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_6_keycode
			elif universal_settings_menu.settings_data.universal_keybind_6_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_6_keycode
		7: # "universal_interact":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_7_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_7_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_7_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_7_keycode
			elif universal_settings_menu.settings_data.universal_keybind_7_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_7_keycode
		8: # "universal_reset":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_8_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_8_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_8_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_8_keycode
			elif universal_settings_menu.settings_data.universal_keybind_8_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_8_keycode
		9: # "universal_exit":
			if set_defaults:
				var event : InputEvent = InputMap.action_get_events(action)[0]
				if (event is InputEventKey):
					universal_settings_menu.settings_data.universal_keybind_9_keycode = int(event.physical_keycode)
				else:
					universal_settings_menu.settings_data.universal_keybind_9_keycode = int(event.button_index)
			elif universal_settings_menu.settings_data.universal_keybind_9_keycode in range(6):
				is_mouse = true
				mouse_bind.button_index = universal_settings_menu.settings_data.universal_keybind_9_keycode
			elif universal_settings_menu.settings_data.universal_keybind_9_keycode > 7:
				key_bind.keycode = universal_settings_menu.settings_data.universal_keybind_9_keycode
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
					universal_settings_menu.settings_data.universal_keybind_0_keycode = key_code
				1: # "move_back":
					universal_settings_menu.settings_data.universal_keybind_1_keycode = key_code
				2: # "move_left":
					universal_settings_menu.settings_data.universal_keybind_2_keycode = key_code
				3: # "move_right":
					universal_settings_menu.settings_data.universal_keybind_3_keycode = key_code
				4: # "run":
					universal_settings_menu.settings_data.universal_keybind_4_keycode = key_code
				5: # "jump":
					universal_settings_menu.settings_data.universal_keybind_5_keycode = key_code
				6: # "fire":
					universal_settings_menu.settings_data.universal_keybind_6_keycode = key_code
				7: # "interact":
					universal_settings_menu.settings_data.universal_keybind_7_keycode = key_code
				8: # "reset":
					universal_settings_menu.settings_data.universal_keybind_8_keycode = key_code
				9: # "exit":
					universal_settings_menu.settings_data.universal_keybind_9_keycode = key_code
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
	

func build_input_action_dictionary():
	input_actions = {}
	if keybinds_config.keybind_action_0 and keybinds_config.keybind_action_0.length() > 0:
		if keybinds_config.keybind_0_desc and keybinds_config.keybind_0_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_0] = keybinds_config.keybind_0_desc
	
	if keybinds_config.keybind_action_1 and keybinds_config.keybind_action_1.length() > 0:
		if keybinds_config.keybind_1_desc and keybinds_config.keybind_1_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_1] = keybinds_config.keybind_1_desc
	
	if keybinds_config.keybind_action_2 and keybinds_config.keybind_action_2.length() > 0:
		if keybinds_config.keybind_2_desc and keybinds_config.keybind_2_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_2] = keybinds_config.keybind_2_desc
	
	if keybinds_config.keybind_action_3 and keybinds_config.keybind_action_3.length() > 0:
		if keybinds_config.keybind_3_desc and keybinds_config.keybind_3_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_3] = keybinds_config.keybind_3_desc
		
	if keybinds_config.keybind_action_4 and keybinds_config.keybind_action_4.length() > 0:
		if keybinds_config.keybind_4_desc and keybinds_config.keybind_4_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_4] = keybinds_config.keybind_4_desc
	
	if keybinds_config.keybind_action_5 and keybinds_config.keybind_action_5.length() > 0:
		if keybinds_config.keybind_5_desc and keybinds_config.keybind_5_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_5] = keybinds_config.keybind_5_desc

	if keybinds_config.keybind_action_6 and keybinds_config.keybind_action_6.length() > 0:
		if keybinds_config.keybind_6_desc and keybinds_config.keybind_6_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_6] = keybinds_config.keybind_6_desc
	
	if keybinds_config.keybind_action_7 and keybinds_config.keybind_action_7.length() > 0:
		if keybinds_config.keybind_7_desc and keybinds_config.keybind_7_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_7] = keybinds_config.keybind_7_desc
		
	if keybinds_config.keybind_action_8 and keybinds_config.keybind_action_8.length() > 0:
		if keybinds_config.keybind_8_desc and keybinds_config.keybind_8_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_8] = keybinds_config.keybind_8_desc
	
	if keybinds_config.keybind_action_9 and keybinds_config.keybind_action_9.length() > 0:
		if keybinds_config.keybind_9_desc and keybinds_config.keybind_9_desc.length() > 0:
			input_actions[keybinds_config.keybind_action_9] = keybinds_config.keybind_9_desc
