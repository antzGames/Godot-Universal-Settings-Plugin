extends Node

# Note you can hide the builtin actions by using this:
#@export_custom(PROPERTY_HINT_INPUT_NAME,"")

@export_category("InputMap Actions")
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_0: StringName : set = set_my_action0
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_1: StringName : set = set_my_action1
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_2: StringName : set = set_my_action2
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_3: StringName : set = set_my_action3
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_4: StringName : set = set_my_action4
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_5: StringName : set = set_my_action5
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_6: StringName : set = set_my_action6
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_7: StringName : set = set_my_action7
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_8: StringName : set = set_my_action8
@export_custom(PROPERTY_HINT_INPUT_NAME,"show_builtin")
var keybind_action_9: StringName : set = set_my_action9


# Note you can use localization keys too
@export_category("Action Description")
@export var keybind_0_desc: StringName
@export var keybind_1_desc: StringName
@export var keybind_2_desc: StringName
@export var keybind_3_desc: StringName
@export var keybind_4_desc: StringName
@export var keybind_5_desc: StringName
@export var keybind_6_desc: StringName
@export var keybind_7_desc: StringName
@export var keybind_8_desc: StringName
@export var keybind_9_desc: StringName


func set_my_action0(value: StringName) -> void:
	keybind_action_0 = value

func set_my_action1(value: StringName) -> void:
	keybind_action_1 = value

func set_my_action2(value: StringName) -> void:
	keybind_action_2 = value

func set_my_action3(value: StringName) -> void:
	keybind_action_3 = value

func set_my_action4(value: StringName) -> void:
	keybind_action_4 = value

func set_my_action5(value: StringName) -> void:
	keybind_action_5 = value

func set_my_action6(value: StringName) -> void:
	keybind_action_6 = value

func set_my_action7(value: StringName) -> void:
	keybind_action_7 = value

func set_my_action8(value: StringName) -> void:
	keybind_action_8 = value

func set_my_action9(value: StringName) -> void:
	keybind_action_9 = value
