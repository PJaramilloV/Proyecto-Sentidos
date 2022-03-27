extends SpringArm

export var mouse_sensitivity := 0.05


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)

		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = clamp(rotation_degrees.y, 0, 360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
