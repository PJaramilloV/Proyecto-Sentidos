extends KinematicBody

export var speed := 500.0
export var jump_strength := 7.0  # 6 tentativo, post grappling
export var gravity := 10.0
export var walk_speed := 440.0
export var crouch_speed := 100.0
export var decal_correction := 0.01

var _velocity := Vector3.ZERO
var _angular_acceleration := 10
var _snap_vector := Vector3.DOWN
var _prep_jump := true
var _jump_timer : float
var _crouching := false
var held_object: Object
var _objects := []
var _pointer := 0

onready var _model: Spatial = $Hero
onready var _stand_shape: CollisionShape = $CollisionShape
onready var _crouch_shape: CollisionShape = $CollisionShapeCrouch

onready var area_grab = $area_grab
onready var _woutline := preload("res://assets/character/woutline.tres")
onready var _youtline := preload("res://assets/character/youtline.tres")

onready var righthand = $Hero/Skeleton/ManoDerechaBone/StaticBody/ManoDerecha
onready var leftfootray = $Hero/Skeleton/PieIzquierdoBone/PieIzquierdoRay
onready var rightfootray = $Hero/Skeleton/PieDerechoBone/PieDerechoRay

onready var decal = preload("res://scenes/Footprint.tscn")

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.z = - Input.get_action_strength("right") + Input.get_action_strength("left")
	move_direction.x = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.normalized()
	
	_velocity.y -= gravity * delta 
	
	_velocity = transform.basis * move_direction * speed * delta + Vector3(0, _velocity.y, 0)
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") and _prep_jump
	
	if is_jumping:
		_prep_jump = false
		$AnimationTree.set("parameters/JumpShot/active", true)
	
	if !_prep_jump:
		_jump_timer += delta
		
	if _jump_timer > 0.45:
		_jump_timer = 0
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
		_prep_jump = true

	if just_landed:
		_snap_vector = Vector3.DOWN
	
	if Input.get_action_strength("right") + Input.get_action_strength("left")  + Input.get_action_strength("back") + Input.get_action_strength("forward") == 0:
		_velocity = move_and_slide(_velocity, Vector3.UP, true)
	else:
		_velocity = move_and_slide(_velocity, Vector3.UP, false)
	
	var vel = sqrt((_velocity.x * _velocity.x)+(_velocity.z * _velocity.z))

	if vel > 0.2:
		var rotate = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * _angular_acceleration) -0.25
		_model.rotation.y = rotate
		_stand_shape.rotation.y = rotate
		_crouch_shape.rotation.y = rotate

	if Input.is_action_pressed("crouch") and is_on_floor():
		_stand_shape.disabled = true
		_crouch_shape.disabled = false
		speed = lerp(speed, move_direction.length()*crouch_speed, 0.05)
		$AnimationTree.set("parameters/StandCrouch/current", 1)
	else :
		_stand_shape.disabled = false
		_crouch_shape.disabled = true
		$AnimationTree.set("parameters/StandCrouch/current", 0)
		if !_prep_jump:
			speed = lerp(speed, move_direction.length()*50, 0.05)
		else:
			speed = lerp(speed, move_direction.length()*walk_speed, 0.05)

	# Animations
	$AnimationTree.set("parameters/IdleWalk/blend_position", vel)
	$AnimationTree.set("parameters/Crouching/blend_position", vel)
	
	### Objetos ###
	
	### Coloreo ###
	if !(_objects.empty()):
		var selected = _objects[_pointer]
		if Input.is_action_just_released("scroll_up"):
			selected.outline(_woutline)
			_pointer += 1
		if Input.is_action_just_released("scroll_down"):
			selected.outline(_woutline)
			_pointer -= 1
		if _pointer < 0:
			_pointer = _objects.size() - 1
		if _pointer >= _objects.size():
			_pointer = 0
			
		selected = _objects[_pointer]
		
		print(_pointer)
		#var selected = _objects[_pointer]
		#var mat = preload
		#mat.albedo_color = Color(1,0,0)
		#var cant = selected.material_count
		#for i in range(cant):
		#	selected.get_node("MeshInstance").set_surface_material(i, _mat)
			#selected.set_material_override()
		selected.outline(_youtline)

	#### Tomar objetos ####
	if Input.is_action_just_pressed("grab"):
		if held_object: #solo entra si ya se tiene el objeto tomado
			held_object.mode = RigidBody.MODE_RIGID
			#held_object.collision_mask = 4
			held_object.collision_mask=2
			
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
		held_object.global_transform.origin = righthand.global_transform.origin
	#### Fin tomar objetos ####
	
	#### Lanzar objectos ####
	if Input.is_action_just_pressed("throw") and is_on_floor() and held_object:
		#print(self.global_transform.origin)
		print("toi lanzando")
		print((get_viewport().get_mouse_position().x-500)/50)
		print((380-get_viewport().get_mouse_position().y)*1.5/30)
		held_object.mode = RigidBody.MODE_RIGID
		held_object.collision_mask=2
		held_object.take_damage(self)
		held_object =  null
		
	### Objetos ###
	
	# jugar con mutiplayer lookip por algo
	# poner planos
	# rehacer todos los assets (plz no)

func _process(delta):
	pass


func _ready():
	#pass # Replace with function body.
	area_grab.connect("body_entered",self,"_on_area_grab_entered")
	area_grab.connect("body_exited",self,"_on_area_grab_exited")

### Surface Painting ###
func rightstep():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = rightfootray.get_collision_normal()*decal_correction
	b.global_transform.origin = rightfootray.get_collision_point() + correction
	b.look_at(rightfootray.get_collision_point() + rightfootray.get_collision_normal(), Vector3.UP)

func leftstep():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = leftfootray.get_collision_normal()*decal_correction
	b.global_transform.origin = leftfootray.get_collision_point() + correction
	b.look_at(leftfootray.get_collision_point() + leftfootray.get_collision_normal(), Vector3.UP)
### Surface Painting ###

func _on_area_grab_entered(body: Node):
	print("colisioné con un objeto tomable")
	body.outline(_woutline)
	_objects.append(body)

func _on_area_grab_exited(body: Node):
	print("salí del área")
	body.outline(null)
	_objects.erase(body)
	if _pointer >= _objects.size():
			_pointer -= 1
	if _pointer < 0:
			_pointer = 0
