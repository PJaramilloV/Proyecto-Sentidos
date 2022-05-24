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
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	var vel = sqrt((player._velocity.x * player._velocity.x)+(player._velocity.z * player._velocity.z))
	
	player.speed = lerp(player.speed, move_direction.length()*player.walk_speed, 0.05)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("crouch"):
		state_machine.transition_to("Crouch")
	elif is_equal_approx(vel, 0.0) and move_direction == Vector3.ZERO:
		state_machine.transition_to("Idle")
