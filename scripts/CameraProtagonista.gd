extends Camera

onready var target: Object = get_parent().get_node("hero")
export var smooth_speed := 6
export var offset: Vector3
	
func _physics_process(delta) -> void:
	if(target != null):
		var destination = target.transform.origin + offset
		destination.x = max(1.845, destination.x)
		self.transform.origin = lerp(self.transform.origin, destination, smooth_speed * delta)
