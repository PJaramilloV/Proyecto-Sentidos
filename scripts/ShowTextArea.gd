extends Area

onready var sprite = get_parent().get_node("Sprite3D")

func _ready():
	pass

func _on_Area_body_entered(body):
	sprite.visible = true
