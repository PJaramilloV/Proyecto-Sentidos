extends MarginContainer

onready var start = $Panel/Fondo/Start
onready var exit = $Panel/Fondo/Exit
onready var options = $Panel/Fondo/Options
onready var extras = $Panel/Fondo/Extras
onready var prueba = $Panel/Fondo/Prueba

var time_in_seconds = 0.2


func _ready():
	start.connect("pressed", self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	extras.connect("pressed", self, "_on_extras_pressed")
	prueba.connect("pressed", self, "_on_prueba_pressed")

func _on_start_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://scenes/levels/LVL_1.tscn")

func _on_exit_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().quit()

func _on_options_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	print("sas")
	get_tree().change_scene("res://scenes/mapa_controles.tscn")

func _on_extras_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://demo/Demo.tscn")	
	
func _on_prueba_pressed():
	$AudioStreamPlayer2D.play()

