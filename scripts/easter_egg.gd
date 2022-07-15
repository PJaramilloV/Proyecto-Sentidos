extends Area

onready var shape = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")


func _on_body_entered(player: Node):
	shape.visible = false
	self.disconnect("body_entered", self, "_on_body_entered")
