extends Node3D

var timer: float
var spawn_timer: float
var distance: float = 7
var cameraLookAt: Vector3 = Vector3(0,5,0)

@export var max_box_count: int = 100
var current_box_count: int

@onready var camera_3d: Camera3D = $Pivot/Camera3D
@onready var godot_plush = $godot_plushV2
@onready var input_info: Label = $HBoxContainer/InputInfo

const ANTZ_BOX = preload("assets/models/antz_box.tscn")

func _ready():

	# If no theme is set then the default Godot theme is used,
	# but you can easily change themes... pick one!
	UniversalSettings.set_theme_to("res://demo/assets/themes/clashy/clashy.tres", Vector2(550,520), Color(1,1,1,0.5))
	#UniversalSettings.set_theme_to("res://demo/assets/themes/windows_10_light/theme.tres", Vector2(550, 345), Color(0,0.471,0.831,0.5))
	#UniversalSettings.set_theme_to("res://demo/assets/themes/windows_10_dark/theme.tres", Vector2(550, 345), Color(1,1,1,1.0))
	#UniversalSettings.set_theme_to("res://demo/assets/themes/kenney/kenneyUI.tres")
	
	UniversalSettings.show_screen()
	camera_3d.position = Vector3(0, 15, 15)

func _input(event: InputEvent):
	# this code will only work for this project's actions
	for a in InputMap.get_actions():
		if a.to_lower().begins_with("universal_"):  # using this projects actions
			if event.is_action(a.to_lower()):
				input_info.text = str("Last action detected: '",a, "' with ", event.as_text().to_upper())
				break
			
	# exit demo and show settings screen
	if event.is_action("ui_cancel") and OS.get_name() != "Web":
		get_tree().quit()
	elif event.is_action_released("ui_accept"): 
		UniversalSettings.show_screen()  # will do nothing if already visible

func _physics_process(delta):
	timer += delta
	spawn_timer += delta
	
	# camera update
	distance = 20+  5 * sin(timer * 0.25)
	camera_3d.position = setFromSpherical(80/PI, timer * 0.25) * distance
	camera_3d.position.y += 10
	camera_3d.look_at(cameraLookAt)
	
	# spawning ANTZ boxes
	if spawn_timer > 0.25 and current_box_count < max_box_count:
		spawn_timer = 0
		var a = ANTZ_BOX.instantiate()
		add_child(a)
		current_box_count += 1

func setFromSpherical(azimuthalAngle: float, polarAngle: float) -> Vector3:
	var cosPolar: float = cos(polarAngle)
	var sinPolar: float = sin(polarAngle)
	var cosAzim: float = cos(azimuthalAngle)
	var sinAzim: float = sin(azimuthalAngle)
	return Vector3(cosAzim * sinPolar, sinAzim * sinPolar, cosPolar)
