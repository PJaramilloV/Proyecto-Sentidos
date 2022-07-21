extends Area

export var area_active : bool
export var text : String
export var pop_up_text : NodePath
export var audio : AudioStream
export var volume := 0.0

var delay_in_seconds := 0.75

func _ready():
	monitoring = area_active
	get_node(pop_up_text).get_node("CenterContainer/Label").text = text
	if audio:
		$AudioStreamPlayer.stream = audio
		$AudioStreamPlayer.volume_db = volume

func trigger():
	set_deferred("monitoring", false)
	get_node(pop_up_text).get_node("AnimationPlayer").play("show")
	$AudioStreamPlayer.play()

func _on_PopUpText_body_entered(body):
	trigger()

func _on_CutsceneActivator3_ended():
	yield(get_tree().create_timer(delay_in_seconds), "timeout")
	trigger()

func _on_CutsceneActivator21_ended():
	yield(get_tree().create_timer(delay_in_seconds), "timeout")
	trigger()

func _on_CutsceneActivator4_ended():
	yield(get_tree().create_timer(delay_in_seconds), "timeout")
	trigger()
