extends Area

export var text : String

onready var player = get_parent().get_node_or_null("Player")

signal say(text)

func _ready():
	if player:
		connect("say", player, "_spirit_say")

func _on_Spatial_body_entered(body):
	set_deferred("monitoring", false)
	emit_signal("say", text)
