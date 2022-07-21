extends Area

signal to_next_level

func _ready():
	pass

func _on_NextLevelArea_body_entered(body):
	monitoring = false
	$wood_open.play()
	emit_signal("to_next_level")
