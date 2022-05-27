extends KinematicBody

export var speed := 1.0
export var jump_strength := 1.0
export var gravity := 2.0
export var timing := 100000.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN
var _timer := 0.0
var held_object: Object
var objeto_recuperado_area: Object
var _objects := []
var _pointer := 0




onready var _model: Spatial = $capsula
onready var _light: Spatial = $PlayerLight
onready var area_grab = $area_grab
onready var _hold_position := get_node("capsula/HoldPosition")
onready var _mat := preload("res://assets/cubotest.tres")

func _physics_process(delta):


	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")


	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta

	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") 

	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO

	if just_landed:
		_snap_vector = Vector3.DOWN

	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)

	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.x, _velocity.z)
		_model.rotation.y = -look_direction.angle()

	if !(_objects.empty()):
		var selected = _objects[_pointer]
		if Input.is_action_just_released("scroll_up"):
			selected.restore()
			_pointer += 1
		if Input.is_action_just_released("scroll_down"):
			selected.restore()
			_pointer -= 1
		if _pointer < 0:
			_pointer = _objects.size() - 1
		if _pointer >= _objects.size():
			_pointer = 0
			
		selected = _objects[_pointer]
		
		#print(_pointer)
		#var selected = _objects[_pointer]
		#var mat = preload
		#mat.albedo_color = Color(1,0,0)
		var cant = selected.material_count
		for i in range(cant):
			selected.get_node("MeshInstance").set_surface_material(i, _mat)
			#selected.set_material_override()

	#### Tomar objetos ####
	if Input.is_action_just_pressed("grab"):
		if held_object: #solo entra si ya se tiene el objeto tomado
			held_object.mode = RigidBody.MODE_RIGID
			#held_object.collision_mask = 4
			held_object.collision_mask=2
			held_object.clear_path()
			held_object =  null
		else:
			#se pasa inmediatamente acá si se apreta la F y no se tiene un objeto tomado
			
			#if objeto_recuperado_area: #se pasa acá si es que el area colisiona y guarda el body con el que choca
			if !(_objects.empty()):
				
				held_object = _objects[_pointer]
				held_object.mode = RigidBody.MODE_KINEMATIC
				held_object.collision_mask=0
	#se pasa acá  cuando se toma un objeto, justo despues de entrar al tomado
	if held_object:
		held_object.global_transform.origin = _hold_position.global_transform.origin
		held_object.display_predicted_trajectory()
		
		
	#### Fin tomar objetos ####
	
	#### Lanzar objectos ####
	if Input.is_action_just_pressed("throw") and is_on_floor() and held_object:
		held_object.mode = RigidBody.MODE_RIGID
		held_object.collision_mask=2
		held_object.take_damage(self)
		held_object =  null
		
	
	if get_slide_count() != 0:
		var col = get_slide_collision(0)
		if col.collider.get_collision_layer() == 1 and _timer > timing:
			var light = load("res://assets/lights.tscn").instance()
			var position = _light.to_global(_light.translation)
			# position.y += 0.1
			light.translate(position)
			#print(position)
			get_parent().add_child(light)
			_timer = 0.0
	
	#print(_pointer)
	#if _objects.empty():
		#print("aaaaaaaaaaaaaaaa")

func _process(delta):
	_timer += delta


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	area_grab.connect("body_entered",self,"_on_area_grab_entered")
	area_grab.connect("body_exited",self,"_on_area_grab_exited")
	
func _on_area_grab_entered(body: Node):
	print("colisioné con un objeto tomable")
	objeto_recuperado_area=body
	_objects.append(body)
	#_pointer += 1

	
func _on_area_grab_exited(body: Node):
	#print("salí del área")
	objeto_recuperado_area=null
	body.restore()
	_objects.erase(body)
	if _pointer >= _objects.size():
			_pointer -= 1
	if _pointer < 0:
			_pointer = 0
	#_pointer -= 1


