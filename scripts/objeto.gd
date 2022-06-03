extends RigidBody
var my_material := []
var material_count
onready var path = get_parent().get_node("trajectory")
var throws_before_break = 4
var thrown = false
var process_function = 'sleep'
var air_time = 0
var AIR_TIME_LIMIT = 0.2
onready var _light_handler: LightHandler = $LightHandler

# get_active_material && get_surface_materia
func _ready():
	material_count = find_node("MeshInstance").get_surface_material_count()
	for i in range(material_count):
		var mat = find_node("MeshInstance").get_surface_material(i)
		my_material.append(mat)

# Funcion nominal process_function(delta)
func sleep(delta):
	pass

# Funcion de timer process_function(delta)
func timer_run(delta):
	air_time += delta
	if(air_time > AIR_TIME_LIMIT):
		self.collision_mask=2
		process_function = 'sleep'
		air_time = 0

# Funcion a llamar en cada frame
func _process(delta):
	call(process_function, delta) # llamar process_function(delta)

# Al ser agarrado, deactivar coll_mask
func grab():
	self.mode = RigidBody.MODE_KINEMATIC
	self.collision_mask=0
	process_function = 'sleep'
	air_time = 0

# Enciende deteccion de colisiones y activa timer
func activate_throw():
	self.mode = RigidBody.MODE_RIGID
	process_function = 'timer_run'
	self.contact_monitor = true   # Detectar siguiente colision
	thrown = true

# Apaga la deteccion de colisiones
func deactivate_hold():
	self.contact_monitor = false   # Detectar siguiente colision
	thrown = false

# Funcion a llamar al soltar objeto
func release():
	clear_path()
	self.mode = RigidBody.MODE_RIGID
	self.collision_mask=2
	deactivate_hold()
	
# Funcion a llamar al lanzar objeto
func throw(instigator: Node):
	clear_path()
	activate_throw()
	# el primero es para lanzar los objetos hacia adelante del personaje
	#apply_central_impulse((self.global_transform.origin - instigator.global_transform.origin)*5)
	var eje_x = get_viewport().get_mouse_position().x
	var eje_y = get_viewport().get_mouse_position().y
	var raton = Vector3(0,clamp((380-eje_y)/30, -3.5, 5),-clamp((eje_x-500)/50, -4.3, 4.3))
	apply_central_impulse(raton)
	
	
# Restorar material de meshes
func restore():
	for i in range(material_count):
		get_node("MeshInstance").set_surface_material(i, my_material[i])

# Aplicar outline al objeto
func outline(material):
	for i in range(material_count):
		var mat = find_node("MeshInstance").get_surface_material(i)
		mat.set_next_pass(material)
		#find_node("MeshInstance").set_surface_material(i, material)
	#var nuevomaterial = SpatialMaterial.new()
	# se puede buscar el hijo que sea mesh con un for y era
	
# Calcular puntos de parabola
func get_predicted_trajectory():
	var delta      = 0.1   # dt entre puntos de trayectoria
	var target_x   = get_viewport().get_mouse_position().x
	var target_y   = get_viewport().get_mouse_position().y
	var pos_0      = self.global_transform.origin
	var vel_0      = Vector3(0,clamp((380-target_y)/30, -3.5, 5),-clamp((target_x-500)/50, -4.3, 4.3))
	var points     = 13   # puntos a calcular despues de la posicion inicial
	var trajectory = [pos_0] 
	# Calcular simple parabola balistica
	for i in range(points):
		# y_1 = y_0 + v_0*t + g*t^2/2
		# z_1 = z_0 + v_0*t
		var t_point = Vector3(pos_0.x, 
							pos_0.y + vel_0.y*delta - 5*delta*delta, 
							pos_0.z + vel_0.z*delta)
		delta += 0.1
		trajectory.append(t_point)
	return trajectory
	
# Graficar parabola desde la posición actual "from_position"
func display_predicted_trajectory(from_position):
	self.global_transform.origin = from_position
	var trajectory_points = get_predicted_trajectory()
	clear_path()
	path.begin(Mesh.PRIMITIVE_LINES, null)
	for point in trajectory_points:
		path.add_vertex(point)
	path.end()

# Borrar parabola
func clear_path():
	path.clear()
	
func create_light(collision: StaticBody):
	var node = collision
	for child in node.get_children():
		if child is VisualHandler:
			_light_handler.create_light(child, global_transform.origin)

# Llamada solo cuando hay una colision monitoreada
func on_body_collided(surface: StaticBody):
	if(! thrown): return # Evitar colisiones dobles
	if(surface is StaticBody): # al colisionar con superficies, ejecutar
		valid_collision(surface)
		if(! throws_before_break): # destruir si se tiro "throws_before_break" veces
			destroy()

# Incluir la generacion de luces aca y sonido (maybe particulas?)
func valid_collision(surface: StaticBody):
	create_light(surface)
	self.contact_monitor = false
	thrown = false
	throws_before_break -= 1

# Añadir sonido despues (?
func destroy():
	get_parent().remove_child(self)
