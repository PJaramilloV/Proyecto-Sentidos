extends RigidBody
var my_material := []
var material_count
onready var path = get_parent().get_node("trajectory")

# get_active_material && get_surface_material

func _ready():
	material_count = find_node("MeshInstance").get_surface_material_count()
	for i in range(material_count):
		var mat = find_node("MeshInstance").get_surface_material(i)
		my_material.append(mat)

func take_damage(instigator: Node):
	clear_path()
	# el primero es para lanzar los objetos hacia adelante del personaje
	#apply_central_impulse((self.global_transform.origin - instigator.global_transform.origin)*5)
	var eje_x = get_viewport().get_mouse_position().x
	var eje_y = get_viewport().get_mouse_position().y
	var raton = Vector3(0,clamp((380-eje_y)/30, -3.5, 5),-clamp((eje_x-500)/50, -4.3, 4.3))
	apply_central_impulse(raton)


func restore():
	for i in range(material_count):
		get_node("MeshInstance").set_surface_material(i, my_material[i])

func outline(material):
	for i in range(material_count):
		var mat = find_node("MeshInstance").get_surface_material(i)
		mat.set_next_pass(material)
		#find_node("MeshInstance").set_surface_material(i, material)
	#var nuevomaterial = SpatialMaterial.new()
	# se puede buscar el hijo que sea mesh con un for y era
	
func get_predicted_trajectory():
	var delta      = 0.1
	var target_x   = get_viewport().get_mouse_position().x
	var target_y   = get_viewport().get_mouse_position().y
	var pos_0      = self.global_transform.origin
	var vel_0      = Vector3(0,clamp((380-target_y)/30, -3.5, 5),-clamp((target_x-500)/50, -4.3, 4.3))
	var points     = 13
	var trajectory = [pos_0] 
	for i in range(points):
		# y_1 = y_0 + v_0*t + g*t^2/2
		# x_1 = x_0 + v_0*t
		var t_point = Vector3(pos_0.x, 
							pos_0.y + vel_0.y*delta - 5*delta*delta, 
							pos_0.z + vel_0.z*delta)
		delta += 0.1
		trajectory.append(t_point)
	return trajectory
	
	
func display_predicted_trajectory():
	var trajectory_points = get_predicted_trajectory()
	clear_path()
	path.begin(Mesh.PRIMITIVE_LINES, null)
	for point in trajectory_points:
		path.add_vertex(point)
	path.end()
	
func clear_path():
	path.clear()
	path.global_translate(Vector3.ZERO)



	
