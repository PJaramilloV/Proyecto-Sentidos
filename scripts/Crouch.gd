extends PlayerState

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/State/current", 1)
	player._stand_shape.disabled = true
	player._crouch_shape.disabled = false

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	var move_direction = player.get_input_direction()
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	var vel = sqrt((player._velocity.x * player._velocity.x)+(player._velocity.z * player._velocity.z))
	
	player.speed = lerp(player.speed, move_direction.length()*player.crouch_speed, 0.05)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_released("crouch"):
		if is_equal_approx(vel, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Jog")
