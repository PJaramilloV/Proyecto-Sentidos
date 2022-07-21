extends Spatial

func _ready():
	pass

func _on_TransitionScreen_transitioned():
	visible = false

func _on_CutsceneActivator_ended():
	visible = false
