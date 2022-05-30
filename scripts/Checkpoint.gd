extends Area

var hero = preload("res://Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_entered(player: Node):
	player.check_point_reached(self)

func respawn(player: Node):
	var level = self.get_parent().get_parent()
	player.queue_free() # borrar player
	# nuevo player, escalar y posicionar en checkpoint
	var new_player = hero.instance()
	new_player.set_scale(Vector3(1.57,1.57,1.57) )
	new_player.translation = self.translation
	new_player.get_node("spirit").flash()
	level.add_child(new_player)

