extends KinematicBody

export var speed: float = 7.0
export var jump_strength: float = 20.0
export var gravity: float = 50.0

var _velocity: Vector3 = Vector3.ZERO
var _snap_vector: Vector3 = Vector3.DOWN

onready var _spring_arm: SpringArm = $SpringArm
onready var _model: Spatial = $CollisionShape
onready var _light_handler: LightHandler = $LightHandler

func movement(delta: float):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()

	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta

	var just_landed: bool = is_on_floor() && _snap_vector == Vector3.ZERO
	var is_jumping: bool = is_on_floor() && Input.is_action_just_pressed("jump")
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)

	if _velocity.length() > 0.2:
		var look_direction: Vector2 = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	
func camera():
	_spring_arm.translation = translation

func create_light(collision: KinematicCollision):
	var node = collision.get_collider()
	for child in node.get_children():
		if child is VisualHandler:
			_light_handler.create_light(child, collision.get_position()+collision.get_normal())

func collision_events(delta):
	if get_slide_count() <= 0:
		return
	var last_collision = get_slide_collision(get_slide_count() - 1)
	if last_collision.get_collider().collision_mask == 1:
		create_light(last_collision)


func _physics_process(delta):
	movement(delta)
	collision_events(delta)

func _process(delta):
	camera()
