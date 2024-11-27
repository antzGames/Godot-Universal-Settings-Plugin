extends RigidBody3D

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector3(randi_range(7,-7), randi_range(25,35), randi_range(7,-7))
	var x = randf_range(0, TAU)
	var y = randf_range(0, TAU)
	var z = randf_range(0, TAU)
	rotation = Vector3(x, y, z)

func _on_timer_timeout():
	position = Vector3(randi_range(7,-7), randi_range(25,35), randi_range(7,-7))
	var x = randf_range(0, TAU)
	var y = randf_range(0, TAU)
	var z = randf_range(0, TAU)
	rotation = Vector3(x, y, z)
	timer.start()
