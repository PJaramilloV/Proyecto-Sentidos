extends Camera

onready var target: Object = get_parent().get_node("hero")
export var smooth_speed := 6
export var offset: Vector3
	
func _physics_process(delta) -> void:
	if(target != null):
		self.transform.origin = lerp(self.transform.origin, target.transform.origin + offset, smooth_speed * delta)
