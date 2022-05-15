extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused =!is_paused	

func set_is_paused(valor):
	is_paused = valor
	get_tree().paused = is_paused
	visible = is_paused



func _on_Resume_pressed():
	self.is_paused = false
	


func _on_Quit_pressed():
	# Como está puesto el menú de pausa y se le da a quit, es como si todavia
	# el menú de pausa sigue activo, por lo que toda la escena sigue pausada
	self.is_paused = false  # Con este se quita al salir
	get_tree().change_scene("res://scenes/main_menu.tscn")


func _on_Options_pause_pressed():
	get_tree().change_scene("res://scenes/mapa_controles.tscn")