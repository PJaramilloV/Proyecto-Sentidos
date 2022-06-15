class_name Player
extends KinematicBody

export var speed := 500.0
export var jump_strength := 7.0  # 6 tentativo, post grappling
export var gravity := 10.0
export var walk_speed := 440.0
export var crouch_speed := 100.0
export var decal_correction := 0.01

var _velocity := Vector3.ZERO
var _angular_acceleration := 10
var held_object: Object
var _objects := []
var _pointer := 0
var _falling_speed := 0.0
var checkpoint : Object
var _hanging := false
var _hang_normal := Vector3.ZERO
var _rotate := true
var prev_vel = 0 # Usada en Lerp animation_tree

### Habilidades ###
export var _brace := false # False por defecto, true para testeo/despues de desbloquear
export var _throw := false
onready var wakeuppath = NodePath("StateMachine/Wakeup")

onready var _model: Spatial = $Hero
onready var _stand_shape: CollisionShape = $CollisionShape
onready var _crouch_shape: CollisionShape = $CollisionShapeCrouch

onready var area_grab = $area_grab
onready var _woutline := preload("res://assets/character/woutline.tres")
onready var _youtline := preload("res://assets/character/youtline.tres")

onready var animation_tree = $AnimationTree

### Raycasts ###
onready var righthand = $Hero/Skeleton/ManoDerechaBone
onready var leftfootray = $Hero/Skeleton/PieIzquierdoBone/PieIzquierdoRay
onready var rightfootray = $Hero/Skeleton/PieDerechoBone/PieDerechoRay
onready var leftfootraydown = $Hero/Skeleton/PieIzquierdoBone/PieIzquierdoRayDown
onready var rightfootraydown = $Hero/Skeleton/PieDerechoBone/PieDerechoRayDown
onready var leftpalmray = $Hero/Skeleton/ManoIzquierdaBone/PalmaIzquierdaRay
onready var rightpalmray = $Hero/Skeleton/ManoDerechaBone/PalmaDerechaRay
onready var leftladderray = $CollisionShape/Raycasts/LeftLadderRay
onready var rightladderray = $CollisionShape/Raycasts/RightLadderRay
onready var leftladderray2 = $CollisionShape/Raycasts/LeftLadderRay2
onready var rightladderray2 = $CollisionShape/Raycasts/RightLadderRay2
onready var centerladderray = $CollisionShape/Raycasts/CenterWorldRay
onready var leftborderray = $CollisionShape/Raycasts/LeftBorderRay
onready var rightborderray = $CollisionShape/Raycasts/RightBorderRay
onready var leftborderray2 = $CollisionShape/Raycasts/LeftBorderRay2
onready var rightborderray2 = $CollisionShape/Raycasts/RightBorderRay2

onready var ladderpath = $ClimbLadderPath
onready var ladderfollow = $ClimbLadderPath/PathFollow

onready var decal = preload("res://scenes/Footprint.tscn")

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	# Esta parte se queda acá de momento. Al implementar, por ejemplo, trepar, esto hay que moverlo (maybe)
	if Input.get_action_strength("right") + Input.get_action_strength("left")  + Input.get_action_strength("back") + Input.get_action_strength("forward") == 0:
		if _hanging:
			_velocity = move_and_slide(_velocity, _hang_normal, true)
		else:
			_velocity = move_and_slide(_velocity, Vector3.UP, true)
	else:
			_velocity = move_and_slide(_velocity, Vector3.UP, false)
	
	var vel = sqrt((_velocity.x * _velocity.x)+(_velocity.z * _velocity.z))
	
	var side = 1
	if Input.get_action_strength("right") - Input.get_action_strength("left") <= 0:
		side = -1

	if _rotate and vel > 0.2: # if vel > 0.2
		var rotate = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * _angular_acceleration) -0.25
		_model.rotation.y = rotate
		_stand_shape.rotation.y = rotate
		_crouch_shape.rotation.y = rotate

	# Animations
	#print(vel)
	prev_vel = lerp(prev_vel, vel, 0.5)
	$AnimationTree.set("parameters/IdleWalk/blend_position", prev_vel)
	$AnimationTree.set("parameters/Crouching/blend_position", prev_vel)
	$AnimationTree.set("parameters/ClimbLadder/blend_position", _velocity.y)
	$AnimationTree.set("parameters/Brace/blend_position", vel*side)
	
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
		
		# Objeto a pintar con outline amarillo
		selected = _objects[_pointer]
		selected.outline(_youtline)

	#### Tomar objetos ####
	if Input.is_action_just_pressed("grab"):
		if held_object: #solo entra si ya se tiene el objeto tomado
			held_object.release()
			held_object =  null
		else:
			#se pasa inmediatamente acá si se apreta la F y no se tiene un objeto tomado
			#if objeto_recuperado_area: #se pasa acá si es que el area colisiona y guarda el body con el que choca
			if !(_objects.empty()):
				held_object = _objects[_pointer]
				held_object.grab()
	#se pasa acá  cuando se toma un objeto, justo despues de entrar al tomado
	if held_object:
		held_object.display_predicted_trajectory(righthand.global_transform.origin)
	#### Fin tomar objetos ####
	
	#### Lanzar objectos ####
	if Input.is_action_just_pressed("throw") and held_object:
		held_object.throw(self)
		held_object =  null
		
	### Objetos ###

func _process(delta):
	pass

func _ready():
	area_grab.connect("body_entered",self,"_on_area_grab_entered")
	area_grab.connect("body_exited",self,"_on_area_grab_exited")
	if _throw:
		learn_throw()

func get_input_direction():
	var move_direction := Vector3.ZERO
	move_direction.x =  Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.normalized()
	return move_direction

### Raycasts Colliding ###

func ladderraycasts():
	var result = []
	if leftladderray.is_colliding():
		result.append(true)
		result.append(leftladderray)
		return result
	elif rightladderray.is_colliding():
		result.append(true)
		result.append(rightladderray)
		return result
	elif leftladderray2.is_colliding():
		result.append(true)
		result.append(leftladderray2)
		return result
	elif rightladderray2.is_colliding():
		result.append(true)
		result.append(rightladderray2)
		return result
	else:
		result.append(false)
		return result

func braceraycasts():
	var result = []
	if leftborderray.is_colliding():
		result.append(true)
		result.append(leftborderray)
		return result
	elif rightborderray.is_colliding():
		result.append(true)
		result.append(rightborderray)
		return result
	elif leftborderray2.is_colliding():
		result.append(true)
		result.append(leftborderray2)
		return result
	elif rightborderray2.is_colliding():
		result.append(true)
		result.append(rightborderray2)
		return result
	else:
		result.append(false)
		return result

### Raycasts Colliding ###

### Surface Painting ###
func rightstep():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = rightfootray.get_collision_normal()*decal_correction
	b.global_transform.origin = rightfootray.get_collision_point() + correction
	b.look_at(rightfootray.get_collision_point() + rightfootray.get_collision_normal(), Vector3.UP)

func leftstepdown():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = leftfootraydown.get_collision_normal()*decal_correction
	b.global_transform.origin = leftfootraydown.get_collision_point() + correction
	b.look_at(leftfootraydown.get_collision_point() + leftfootraydown.get_collision_normal(), Vector3.UP)
	
func rightstepdown():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = rightfootraydown.get_collision_normal()*decal_correction
	b.global_transform.origin = rightfootraydown.get_collision_point() + correction
	b.look_at(rightfootraydown.get_collision_point() + rightfootraydown.get_collision_normal(), Vector3.UP)

func leftstep():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = leftfootray.get_collision_normal()*decal_correction
	b.global_transform.origin = leftfootray.get_collision_point() + correction
	b.look_at(leftfootray.get_collision_point() + leftfootray.get_collision_normal(), Vector3.UP)

func rightpalm():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = rightpalmray.get_collision_normal()*decal_correction
	b.global_transform.origin = rightpalmray.get_collision_point() + correction
	b.look_at(rightpalmray.get_collision_point() + rightpalmray.get_collision_normal(), Vector3.UP)

func leftpalm():
	var b = decal.instance()
	get_parent().add_child(b)
	var correction = leftpalmray.get_collision_normal()*decal_correction
	b.global_transform.origin = leftpalmray.get_collision_point() + correction
	b.look_at(leftpalmray.get_collision_point() + leftpalmray.get_collision_normal(), Vector3.UP)
	
### Surface Painting ###

func _on_area_grab_entered(body: Node):
	body.outline(_woutline)
	_objects.append(body)

func _on_area_grab_exited(body: Node):
	body.outline(null)
	_objects.erase(body)
	if _pointer >= _objects.size():
			_pointer -= 1
	if _pointer < 0:
			_pointer = 0

func learn_throw():
	_throw = true
	area_grab.monitoring = true

# Almacenar referencia al checkpoint
func check_point_reached(cp_area: Node):
	if checkpoint != cp_area:
		checkpoint = cp_area

# Al morir respawnear el Player desde el checkpoint
func death():
	checkpoint.respawn(self.get_parent())

# Mover al personaje en cinemática
func move_to(pos: Vector3, radius: float):
	print("omivendo heroe")
	$StateMachine._move_to(pos, radius)
