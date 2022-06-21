extends PlayerState

var _max_speed := 0.833 # Calculada jugando xd
var border_normal : Vector3

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/BraceTransition/current", 1)
	player._stand_shape.disabled = true
	player._crouch_shape.disabled = false
	player._velocity = Vector3.ZERO
	player._rotate = false
	# Rotación / Mirar el borde
	var correction = 1.715 # Ajuste a mano de la posicion del pj.
	if msg.has("ray"):
		var ray = msg.get("ray")
		var dir = ray.get_collision_normal()
		border_normal = dir
		player._model.look_at(dir + player._model.global_transform.origin, Vector3.UP)
		player._stand_shape.look_at(dir + player._stand_shape.global_transform.origin, Vector3.UP)
		player._crouch_shape.look_at(dir + player._crouch_shape.global_transform.origin, Vector3.UP)
		var height = ray.get_collider().global_transform.origin.y #- player.global_transform.origin.y
		player.global_transform.origin = ray.get_collision_point() + dir * 0.5
		player.global_transform.origin.y = height - correction
	player.leftladderray.enabled = false
	player.leftladderray2.enabled = false
	player.rightborderray.enabled = false
	player.rightborderray2.enabled = false
	### Apagamos rayos de Brace ###
	player.leftborderray2.enabled = false
	player.rightborderray2.enabled = false
	player.leftborderray.enabled = true
	player.rightborderray.enabled = true

func exit() -> void:
	player.animation_tree.set("parameters/BraceTransition/current", 0)
	player._rotate = true
	player.leftladderray.enabled = true
	player.leftladderray2.enabled = true
	player.rightborderray.enabled = true
	player.rightborderray2.enabled = true
	### Encendemos rayos de Brace ###
	player.leftborderray2.enabled = true
	player.rightborderray2.enabled = true
	player.leftborderray.enabled = false
	player.rightborderray.enabled = false

func physics_update(delta: float) -> void:
	# (player.leftladderray.is_colliding() or player.rightladderray.is_colliding())
	var move_direction = player.get_input_direction()
	var move_border = move_direction.project(border_normal)
	
	player._velocity = player.transform.basis * move_border * 100.0 * delta 
	
#	print(player._velocity.y)
	
	if !player.leftborderray.is_colliding() and !player.rightborderray.is_colliding():
		print("me suelto")
		state_machine.transition_to("Air")
		return
	
	if Input.is_action_just_pressed("interact"):
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true, force = true})
