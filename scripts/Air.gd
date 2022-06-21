extends PlayerState

var _prep_jump := true
var _jump_timer : float

func enter(msg := {}) -> void:
	player._stand_shape.disabled = false
	player._crouch_shape.disabled = true
	if msg.has("do_jump"):
		if msg.has("force"):
			player.animation_tree.set("parameters/RunningJumpShot/active", true)
			player.animation_tree.set("parameters/Falling/current", 1)
			player._velocity.y = player.jump_strength * 0.9
		elif sqrt((player._velocity.x * player._velocity.x)+(player._velocity.z * player._velocity.z)) > 0.5:
			player.animation_tree.set("parameters/RunningJumpShot/active", true)
			player.animation_tree.set("parameters/Falling/current", 1)
			player._velocity.y = player.jump_strength * 0.8
		else:
			_prep_jump = false
			player.animation_tree.set("parameters/JumpShot/active", true)
	### Encendemos rayos de Brace ###
	player.leftborderray.enabled = true
	player.leftborderray2.enabled = true
	player.rightborderray.enabled = true
	player.rightborderray2.enabled = true

func exit() -> void:
	player.animation_tree.set("parameters/Falling/current", 0)
	### Apagar todas las oneShot ###
	player.animation_tree.set("parameters/RunningJumpShot/active", false)
	player.animation_tree.set("parameters/JumpShot/active", false)
	### Apagamos rayos de Brace ###
	player.leftborderray.enabled = false
	player.leftborderray2.enabled = false
	player.rightborderray.enabled = false
	player.rightborderray2.enabled = false

func physics_update(delta: float) -> void:
	var move_direction = player.get_input_direction()
	player._velocity.y -= player.gravity * delta 
	
	player._velocity = player.transform.basis * move_direction * player.speed * delta + Vector3(0, player._velocity.y, 0)
	
	# Landing.
	if player.is_on_floor() and _prep_jump:
		### Apagar todas las oneShot ###
		player.animation_tree.set("parameters/Falling/current", 0)
		
		var landing_speed = player._falling_speed
		player._falling_speed = 0
		if landing_speed < -13:
			#_hard_land = true
			player.animation_tree.set("parameters/HardLandShot/active", true)
			state_machine.transition_to("Idle", {hard_land = true})
			return
		#_snap_vector = Vector3.DOWN
		else:
			state_machine.transition_to("Idle", {land = true})
			return
	else:
		player._falling_speed = player._velocity.y
		
	if !_prep_jump:
		_jump_timer += delta
	
	if _jump_timer > 0.45:
		_jump_timer = 0
		player._velocity.y = player.jump_strength
		_prep_jump = true
		player.animation_tree.set("parameters/Falling/current", 1)
	
	if player._falling_speed < -3:
		player.animation_tree.set("parameters/Falling/current", 1)
	
	if !_prep_jump:
		player.speed = lerp(player.speed, move_direction.length()*50, 0.05)
	else:
		player.speed = lerp(player.speed, move_direction.length()*player.walk_speed, 0.05)
		
	if Input.is_action_just_pressed("interact"):
		var ladder = player.ladderraycasts()
		if ladder[0]:
			state_machine.transition_to("Ladder", {ray=ladder[1]})
			return
	
	if Input.is_action_just_pressed("interact") and player._brace:
		var brace = player.braceraycasts()
		if brace[0]:
			state_machine.transition_to("Brace", {ray=brace[1]})
