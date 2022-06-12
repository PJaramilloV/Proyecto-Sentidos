extends PlayerState

var _max_speed := 0.833 # Calculada jugando xd
var border_normal : Vector3

func enter(msg := {}) -> void:
	player.animation_tree.set("parameters/State/current", 0)
	player._stand_shape.disabled = false
	player._crouch_shape.disabled = true

func exit() -> void:
	player.animation_tree.set("parameters/BraceTransition/current", 0)
	player._rotate = true

func physics_update(delta: float) -> void:
	pass
