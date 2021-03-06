extends PlayerState

var _max_speed := 0.833 # Calculada jugando xd
### Esto es para despues, si queremos ser más exquisitos con los movimientos ###
#var path : Path # Movimiento de subir sobre la escalera
#var follow : PathFollow
#var climbing = false
### Esto es para despues, si queremos ser más exquisitos con los movimientos ###

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/LadderTransition/current", 1)
	player._stand_shape.disabled = true
	player._crouch_shape.disabled = false
	player._velocity = Vector3.ZERO
	# Rotación / Mirar la escalera
	# var pos = player.rightladderray.get_collision_point()
	if msg.has("ray"):
		var ray = msg.get("ray")
		var dir = ray.get_collision_normal()
		player._model.look_at(dir + player._model.global_transform.origin, Vector3.UP)
		player._stand_shape.look_at(dir + player._stand_shape.global_transform.origin, Vector3.UP)
		player._crouch_shape.look_at(dir + player._crouch_shape.global_transform.origin, Vector3.UP)
		dir.x = -dir.x
		dir.z = -dir.z
		player._hang_normal = dir
		var pos = ray.get_collision_point() - ray.global_transform.origin
		player.translate(Vector3(-pos.z, pos.y, -pos.x))
	player.leftborderray.enabled = false
	player.leftborderray2.enabled = false
	player.rightborderray.enabled = false
	player.rightborderray2.enabled = false

func exit() -> void:
	player.animation_tree.set("parameters/LadderTransition/current", 0)
#	player.animation_tree.set("parameters/ClimbLadderShot/active", false)
	player.leftborderray.enabled = true
	player.leftborderray2.enabled = true
	player.rightborderray.enabled = true
	player.rightborderray2.enabled = true

func physics_update(delta: float) -> void:
	if !player.leftladderray.is_colliding() and !player.rightladderray.is_colliding():
		if  Input.is_action_pressed("forward") :
			state_machine.transition_to("Air", {do_jump = true, force = true})
			return
		else :
			state_machine.transition_to("Air")
			return
			
		### Esto es para despues, si queremos ser más exquisitos con los movimientos ###
#		climbing = true
#		path = player.ladderpath
#		follow = player.ladderfollow
#		player.animation_tree.set("parameters/ClimbLadderShot/active", true)
		### Esto es para despues, si queremos ser más exquisitos con los movimientos ###
	
	### Esto es para despues, si queremos ser más exquisitos con los movimientos ###
#	if climbing:
#		var offset = follow.unit_offset
#		if offset + delta >= 1:
#			climbing = false
#			state_machine.transition_to("Crouch")
#			return
#		follow.unit_offset = offset + delta
#		var pos = follow.global_transform.origin - player.global_transform.origin
#		player.translate(Vector3(-pos.z, pos.y, -pos.x))
	### Esto es para despues, si queremos ser más exquisitos con los movimientos ###
	
	# (player.leftladderray.is_colliding() or player.rightladderray.is_colliding())
	var move_direction = Input.get_action_strength("forward") - Input.get_action_strength("back")
	
	player._velocity.y = delta * move_direction * 50.0 # /119.0
	
#	print(player._velocity.y)
	
	if Input.is_action_just_pressed("interact"):
			if not player.is_on_floor():
				state_machine.transition_to("Air")
			else:
				state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true, force = true})
