extends CanvasLayer

signal transitioned
signal main_menu
signal game_over
signal next_level
signal level_0
signal continuen
signal extra
signal close
signal lose

func transition():
	$AnimationPlayer.play("fade_to_black")

func transition_to_level_0():
	$AnimationPlayer.play("fade_to_black_level_0")

func transition_to_menu():
	$AnimationPlayer.play("fade_to_black_menu")

func transition_next_level():
	$AnimationPlayer.play("fade_to_black_next_level")

func transition_continue():
	$AnimationPlayer.play("fade_to_black_continue")

func transition_extra():
	$AnimationPlayer.play("fade_to_black_extra")

func transition_lose():
	$AnimationPlayer.play("fade_to_black_lose")

func transition_close():
	$AnimationPlayer.play("fade_to_black_close")

func restore():
	$AnimationPlayer.play("fade_to_normal")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		#print("Emit signal transitioned")
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_menu":
		emit_signal("main_menu")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_next_level":
		emit_signal("next_level")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_level_0":
		emit_signal("level_0")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_continue":
		emit_signal("continuen")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_extra":
		emit_signal("extra")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_close":
		emit_signal("close")
		$AnimationPlayer.play("fade_to_normal")
	elif anim_name == "fade_to_black_lose":
		emit_signal("lose")
		$AnimationPlayer.play("fade_to_normal_lose")
