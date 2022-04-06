extends KinematicBody

export var speed := 1.0
export var jump_strength := 1.0
export var gravity := 2.0
export var timing := 100000.0

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN
var _timer := 0.0


onready var _model: Spatial = $capsula
onready var _light: Spatial = $PlayerLight


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

		# !!!! lerp !!!! Vec3 position pos jugador + mov -> rogue gire hacia ese Vec3 en look at
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.x, _velocity.z)
		_model.rotation.y = -look_direction.angle()

	if get_slide_count() != 0:
		var col = get_slide_collision(0)
		if col.collider.get_collision_layer() == 1 and _timer > timing:
			var light = load("res://assets/lights.tscn").instance()
			var position = _light.to_global(_light.translation)
			# position.y += 0.1
			light.translate(position)
			print(position)
			get_parent().add_child(light)
			_timer = 0.0

func _process(delta):
	_timer += delta


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
