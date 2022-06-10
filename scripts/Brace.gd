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
	var correction = 3.5 # 3.5 # Ajuste a mano de la posicion del pj. !!!Distinto en Demo y LVLs!!!
	if msg.has("ray"):
		var ray = msg.get("ray")
		var dir = ray.get_collision_normal()
		border_normal = dir
		player._model.look_at(dir + player._model.global_transform.origin, Vector3.UP)
		player._stand_shape.look_at(dir + player._stand_shape.global_transform.origin, Vector3.UP)
		player._crouch_shape.look_at(dir + player._crouch_shape.global_transform.origin, Vector3.UP)
		var pos = ray.get_collision_point() - ray.global_transform.origin
		var height = ray.get_collider().global_transform.origin.y #- player.global_transform.origin.y
		player.translate(Vector3(-pos.z, height - correction, -pos.x))

func exit() -> void:
	player.animation_tree.set("parameters/BraceTransition/current", 0)
	player._rotate = true

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
