extends Area

export var area_active : bool
export var text : String
export var pop_up_text : NodePath
export var audio : AudioStream

func _ready():
	monitoring = area_active
	get_node(pop_up_text).get_node("CenterContainer/Label").text = text
	if audio:
		$AudioStreamPlayer.stream = audio

func trigger():
	set_deferred("monitoring", false)
	get_node(pop_up_text).get_node("AnimationPlayer").play("show")
	$AudioStreamPlayer.play()

func _on_PopUpText_body_entered(body):
	trigger()
