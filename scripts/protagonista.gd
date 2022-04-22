extends KinematicBody

export var speed := 250.0
export var jump_strength := 3.0
export var gravity := 10.0
export var walk_speed := 220.0
export var crouch_speed := 100.0

var _velocity := Vector3.ZERO
var _angular_acceleration := 10
var _snap_vector := Vector3.DOWN
var _prep_jump := true
var _jump_timer : float
var _crouching := false

onready var _model: Spatial = $Rogue

onready var leftfootray = $Rogue/Skeleton/PieIzquierdoBone/PieIzquierdoRay
onready var rightfootray = $Rogue/Skeleton/PieDerechoBone/PieDerechoRay

onready var decal = preload("res://scenes/Footprint.tscn")

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	#move_direction = move_direction.rotated(Vector3.UP, )
	move_direction = move_direction.normalized()
	
	#_velocity.x = move_direction.x * speed
	#_velocity.z = move_direction.z * speed
	#var gravity_resistance = get_floor_normal() if is_on_floor() else Vector3.UP
	_velocity.y -= gravity * delta 
	#_velocity -= gravity_resistance * gravity * delta
	
	_velocity = transform.basis * move_direction * speed * delta + Vector3(0, _velocity.y, 0)
	
	#print(_velocity.length())
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump") and _prep_jump
	
	if is_jumping:
		#_velocity.y = jump_strength
		#_snap_vector = Vector3.ZERO
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
		_model.rotation.y = lerp_angle(_model.rotation.y, atan2(_velocity.x, _velocity.z), delta * _angular_acceleration)

	if Input.is_action_pressed("crouch"):
		speed = lerp(speed, move_direction.length()*crouch_speed, 0.05)
		$AnimationTree.set("parameters/StandCrouch/current", 1)
	else :
		speed = lerp(speed, move_direction.length()*walk_speed, 0.05)
		$AnimationTree.set("parameters/StandCrouch/current", 0)

	# Animations
	$AnimationTree.set("parameters/IdleWalk/blend_position", vel)
	$AnimationTree.set("parameters/Crouching/blend_position", vel)
	
	# Surface Painting
	if leftfootray.is_colliding():
		var b = decal.instance()
		leftfootray.get_collider().add_child(b)
		b.global_transform.origin = leftfootray.get_collision_point()
		b.look_at(leftfootray.get_collision_point() + leftfootray.get_collision_normal(), Vector3.UP)

	if rightfootray.is_colliding():
		var b = decal.instance()
		rightfootray.get_collider().add_child(b)
		b.global_transform.origin = rightfootray.get_collision_point()
		b.look_at(rightfootray.get_collision_point() + rightfootray.get_collision_normal(), Vector3.UP)	
	# jugar con mutiplayer lookip por algo
	# poner planos
	# rehacer todos los assets (plz no)
	print(_velocity)

func _process(delta):
	pass


func _ready():
	pass # Replace with function body.
