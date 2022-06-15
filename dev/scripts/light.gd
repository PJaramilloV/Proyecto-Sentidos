extends OmniLight

export var animated: bool = true
export var max_timer: float = 0.2

var _l_owner: VisualHandler = null setget set_light_owner, get_light_owner

var _max_radius: float = 0.0
var timer: float = 0.0

var _active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_max_radius = omni_range
	_active = true
	if animated:
		for mesh in get_light_owner().get_meshes():
			pass
			# mesh.set_layer_mask(9) # bit 3 + bit 0
		# set_cull_mask(9)
		omni_range = 0.0

func disappear():
	_active = false
	if animated:
		timer = 0.0
	

func set_light_owner(owner: VisualHandler) -> void:
	_l_owner = owner

func get_light_owner() -> VisualHandler:
	return _l_owner
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animated && max_timer > timer:
		timer += delta
		if _active:
			omni_range = _max_radius * timer / max_timer
		else:
			omni_range = _max_radius * (max_timer - timer) / max_timer
			if timer > max_timer:
				self.queue_free()
	
		# print(global_transform.origin)
		
