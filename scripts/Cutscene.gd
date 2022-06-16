extends PlayerState

var _cutscene_velocity := Vector3.ZERO
var _target_pos : Vector3
var _target_distance : float

func enter(msg := {}) -> void:
	print("aora custcene")
	player.animation_tree.set("parameters/State/current", 0)
	player._stand_shape.disabled = false
	player._crouch_shape.disabled = true

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	player._velocity = _cutscene_velocity * delta
	update_move_vel()

func update_move_vel() -> void:
	var player_pos = player.global_transform.origin
	if _target_pos.distance_to(player_pos) > _target_distance:
		var dir = _target_pos - player_pos
		dir.y = 0
		var speed_dir = dir.normalized()
		speed_dir = player.transform.basis * speed_dir * player.walk_speed
		_cutscene_velocity = Vector3(-speed_dir.z,0,speed_dir.x)
	else:
		_cutscene_velocity = Vector3.ZERO

func move_to(pos: Vector3, radius: float) -> void:
	print("owoo")
	_target_distance = radius
	_target_pos = pos
	update_move_vel()
