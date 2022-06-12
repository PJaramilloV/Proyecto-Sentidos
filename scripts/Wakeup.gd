extends PlayerState

var _timer = 0.0

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/WakeupShot/active", true)

func physics_update(delta: float) -> void:
	player._velocity.y -= player.gravity * delta 
	
	_timer += delta
	if _timer > 13.3:
		state_machine.transition_to("Idle")
