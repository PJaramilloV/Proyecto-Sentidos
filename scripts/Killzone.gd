extends Area

signal death

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_area_entered(player: Node):
	emit_signal("death")
	player.death()
