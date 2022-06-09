extends MarginContainer

onready var start = $Panel/Fondo/Start
onready var exit = $Panel/Fondo/Exit
onready var options = $Panel/Fondo/Options
onready var extras = $Panel/Fondo/Extras
onready var settings_menu = $Settings_Menu

var time_in_seconds = 0.2


func _ready():
	start.connect("pressed", self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	extras.connect("pressed", self, "_on_extras_pressed")

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
	settings_menu.popup_centered()

func _on_extras_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://demo/DemoHero.tscn")	


