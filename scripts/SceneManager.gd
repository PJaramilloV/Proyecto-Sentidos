extends Node2D

const SceneTwo = preload("res://scenes/levels/LVL_1.tscn")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$TransitionScreen.transition()

func _on_TransitionScreen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(SceneTwo.instance())
	print("Swapped in SceneTwo")
