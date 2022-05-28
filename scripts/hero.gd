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

onready var _model: Spatial = $Hero
onready var _stand_shape: CollisionShape = $CollisionShape
onready var _crouch_shape: CollisionShape = $CollisionShapeCrouch

onready var area_grab = $area_grab
onready var _woutline := preload("res://assets/character/woutline.tres")
onready var _youtline := preload("res://assets/character/youtline.tres")

onready var animation_tree = $AnimationTree

onready var righthand = $Hero/Skeleton/ManoDerechaBone
onready var leftfootray = $Hero/Skeleton/PieIzquierdoBone/PieIzquierdoRay
onready var rightfootray = $Hero/Skeleton/PieDerechoBone/PieDerechoRay

onready var decal = preload("res://scenes/Footprint.tscn")

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	# Esta parte se queda acá de momento. Al implementar, por ejemplo, trepar, esto hay que moverlo (maybe)
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

func get_input_direction():
	var move_direction := Vector3.ZERO
	move_direction.x =  Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.normalized()
	return move_direction

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
	body.outline(_woutline)
	_objects.append(body)

func _on_area_grab_exited(body: Node):
	body.outline(null)
	_objects.erase(body)
	if _pointer >= _objects.size():
			_pointer -= 1
	if _pointer < 0:
			_pointer = 0


# Almacenar referencia al checkpoint
func check_point_reached(cp_area: Node):
	if checkpoint != cp_area:
		checkpoint = cp_area

# Al morir respawnear el Player desde el checkpoint
func death():
	checkpoint.respawn(self.get_parent())
