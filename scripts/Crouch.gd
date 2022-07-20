extends PlayerState

var _jump_timer
var raycasts = []

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/State/current", 1)
	player._stand_shape.disabled = true
	player._crouch_shape.disabled = false
	_jump_timer = 0
	if msg.has("standcrouch"):
		player.animation_tree.set("parameters/SCShot/active", true)
	raycasts = [player.crouchray1, player.crouchray2, player.crouchray3, player.crouchray4]
	for ray in raycasts:
		ray.enabled = true

func exit() -> void:
	for ray in raycasts:
		ray.enabled = false

func physics_update(delta: float) -> void:
	if (!player.is_on_floor()) and !player.floorray.is_colliding():
		_jump_timer += delta
		if _jump_timer >= 0.175:
			state_machine.transition_to("Air")
			return
	else:
		_jump_timer = 0
	var move_direction = player.get_input_direction()
	
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	var vel = sqrt((player._velocity.x * player._velocity.x)+(player._velocity.z * player._velocity.z))
	
	player.speed = lerp(player.speed, move_direction.length()*player.crouch_speed, 0.05)
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("interact"):
		var ladder = player.ladderraycasts()
		if ladder[0]:
			state_machine.transition_to("Ladder", {ray=ladder[1]})
	elif !Input.is_action_pressed("crouch") and can_stand():
		if is_equal_approx(vel, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Jog")

func can_stand():
	for ray in raycasts:
		if ray.is_colliding():
			return false
	return true
