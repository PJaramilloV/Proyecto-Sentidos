extends PlayerState

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/State/current", 0)
	player._stand_shape.disabled = false
	player._crouch_shape.disabled = true

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	var move_direction = player.get_input_direction()
	
	var prev_velocity = player._velocity
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	var vel = sqrt((player._velocity.x * player._velocity.x)+(player._velocity.z * player._velocity.z))
	var prev_vel = sqrt((prev_velocity.x * prev_velocity.x)+(prev_velocity.z * prev_velocity.z))

	player.speed = lerp(player.speed, move_direction.length()*player.walk_speed, 0.05)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("crouch"):
		state_machine.transition_to("Crouch")
	elif Input.is_action_just_pressed("interact"):
		var ladder = player.ladderraycasts()
		if ladder[0]:
			state_machine.transition_to("Ladder", {ray=ladder[1]})
	elif prev_vel > 2 and move_direction == Vector3.ZERO:
		state_machine.transition_to("Idle", {stop=true})
	elif is_equal_approx(vel, 0.0) and move_direction == Vector3.ZERO:
		state_machine.transition_to("Idle")
