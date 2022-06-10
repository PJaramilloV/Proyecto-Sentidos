extends Camera

onready var target: Object = get_parent().get_node("hero")
export var smooth_speed := 6
export var offset: Vector3
	
func _physics_process(delta) -> void:
	if(target != null):
		var destination = target.global_transform.origin + offset
		destination.x = max(3.845, destination.x)
		self.global_transform.origin = lerp(self.global_transform.origin, destination, smooth_speed * delta)

func reset():
	var destination = target.global_transform.origin + offset
	destination.x = max(3.845, destination.x)
	self.global_transform.origin = destination
