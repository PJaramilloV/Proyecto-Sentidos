extends Node
class_name LightHandler

export var max_lights: int = 24
export var scale: float = 1.5

onready var base_light: PackedScene = preload("res://assets/abstract/step_light.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_light(handler: VisualHandler, position: Vector3):
	for child in get_children():
		if child.get_light_owner() == handler:
			var pos = child.translation
			var dist = position.distance_to(pos)
			if dist < child.omni_range*scale:
				return

	var new_light = base_light.instance()
	new_light.translation = position
	if handler.setup_light(new_light, self):
		add_child(new_light)
		check_overflow()

func check_overflow():
	if get_child_count() > max_lights:
		var first_child = get_child(0)
		first_child.get_light_owner().remove_light()
		remove_child(first_child)
		first_child.free()

func clear_light(handler: VisualHandler):
	for child in get_children():
		if child.get_light_owner() == handler:
			remove_child(child)
			child.free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
