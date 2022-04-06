extends KinematicBody

export var speed := 2.0
export var jump_strength := 5.0
export var gravity := 10.0
export var walk_speed := 1.0
export var crouch_speed := 0.4

var _velocity := Vector3.ZERO
var _angular_acceleration := 10
var _snap_vector := Vector3.DOWN

onready var _model: Spatial = $Rogue

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	#move_direction = move_direction.rotated(Vector3.UP, )
	move_direction = move_direction.normalized()
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	print(_velocity.length())
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") 
	
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO

	if just_landed:
		_snap_vector = Vector3.DOWN
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * _angular_acceleration)

	if Input.is_action_pressed("crouch"):
		speed = lerp(speed, _velocity.length()*crouch_speed, 0.05)
	else:
		speed = lerp(speed, _velocity.length()*walk_speed, 0.05)

	# Animations
	$AnimationTree.set("parameters/IdleWalk/blend_position", _velocity.length())

func _process(delta):
	pass


	
func _ready():
	pass # Replace with function body.
