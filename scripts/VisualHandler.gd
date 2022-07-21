extends Node
class_name VisualHandler

export var max_lights: int = 5

var _n_lights: int = 0
var _meshes: = [] setget , get_meshes
var _changed: bool = false

func _ready():
	find_meshes(get_parent())
	assert(get_parent() is PhysicsBody, "ERROR: VisualHandler must be a child of a PhysicsBody")

func find_meshes(node: Node):
	if node is MeshInstance:
		_meshes.append(node)
	if node.get_child_count() > 0:
		for child in node.get_children():
			find_meshes(child)

func get_meshes():
	if _meshes.size() == 0:
		find_meshes(get_parent())
	return _meshes

func setup_light(light: Light, handler) -> bool:
	if _n_lights >= max_lights || !light.has_method("set_light_owner"):
		if !_changed:
			_changed = true
			handler.clear_light(self)
			for mesh in get_meshes():
				mesh.set_layer_mask(4)
				var material = mesh.mesh.surface_get_material(0)
				var new_material = material.duplicate()
				mesh.set_surface_material(0, new_material)
				new_material.emission_enabled = true
				new_material.emission = Color(0.099,0.099,0.099)
				new_material.emission_energy = 2
				
		return false
	light.set_light_owner(self)
	_n_lights += 1
	return true

func remove_light():
	if !_changed:
		_n_lights -= 1
