extends PlayerState

var _hard_land := false
var _land_timer : float
var _pose_timer = 0.0
var _pose_choice = 0
var _pose_timer_choice = 0.0
var _pose_times = [20, 35, 50]

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/State/current", 0)
	player._stand_shape.disabled = false
	player._crouch_shape.disabled = true
	if msg.has("hard_land"):
		_hard_land = true
	if msg.has("stop"):
		player.animation_tree.set("parameters/JogStopShot/active", true)
#	if msg.has("land"):
#		player.animation_tree.set("parameters/LandShot/active", true)
	_pose_timer_choice = _pose_times[randi() % _pose_times.size()]
	_pose_choice = randi() % 3

func exit() -> void:
	player.animation_tree.set("parameters/JogStopShot/active", false)
	#player.animation_tree.set("parameters/LandShot/active", false)
	player.animation_tree.set("parameters/IdlePose1/active", false)
	player.animation_tree.set("parameters/IdlePose2/active", false)
	player.animation_tree.set("parameters/IdlePose3/active", false)

func physics_update(delta: float) -> void:
	if (!player.is_on_floor()) and !player.floorray.is_colliding():
		state_machine.transition_to("Air")
		return
		
	var move_direction = player.get_input_direction()
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	if _pose_timer < _pose_timer_choice:
		_pose_timer += delta
	else:
		_pose_timer = 0
		match _pose_choice:
			0:
				player.animation_tree.set("parameters/IdlePose1/active", true)
			1:
				player.animation_tree.set("parameters/IdlePose2/active", true)
			2:
				player.animation_tree.set("parameters/IdlePose3/active", true)
		_pose_timer_choice = _pose_times[randi() % _pose_times.size()]
		_pose_choice = randi() % 3
	
	if _hard_land:
		player._velocity.x = 0
		player._velocity.z = 0
		_land_timer += delta
	
	if _land_timer > 1.3:
		_land_timer = 0
		_hard_land = false

	if not _hard_land:
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Air", {do_jump = true})
		elif Input.is_action_just_pressed("crouch"):
			state_machine.transition_to("Crouch", {standcrouch = true})
		elif Input.is_action_just_pressed("interact"):
			var ladder = player.ladderraycasts()
			if ladder[0]:
				state_machine.transition_to("Ladder", {ray=ladder[1]})
		elif move_direction != Vector3.ZERO:
			state_machine.transition_to("Jog")
