extends PlayerState

var _hard_land := false
var _land_timer : float

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

func exit() -> void:
	player.animation_tree.set("parameters/JogStopShot/active", false)
	#player.animation_tree.set("parameters/LandShot/active", false)

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	var move_direction = player.get_input_direction()
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
		
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
			state_machine.transition_to("Crouch")
		elif Input.is_action_just_pressed("interact"):
			if player.leftladderray.is_colliding():
				state_machine.transition_to("Ladder", {left=true})
			elif player.rightladderray.is_colliding():
				state_machine.transition_to("Ladder", {right=true})
		elif move_direction != Vector3.ZERO:
			state_machine.transition_to("Jog")
