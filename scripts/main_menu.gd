extends Control

onready var continueb = $Panel/Fondo/Continue
onready var start = $Panel/Fondo/Start
onready var exit = $Panel/Fondo/Exit
onready var options = $Panel/Fondo/Options
onready var extras = $Panel/Fondo/Extras
onready var credits = $Panel/Fondo/Credits
onready var settings_menu = $Settings_Menu
onready var background = $MainMenu2
var level : int

signal startgame
signal continuegame(level)
signal extra
signal close
signal credits

var time_in_seconds = 0.2

func _ready():
	continueb.connect("pressed", self, "_on_continue_pressed")
	start.connect("pressed", self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	extras.connect("pressed", self, "_on_extras_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	load_level()
	if level != 0:
		continueb.visible = true

func _on_continue_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("continuegame", level)

func _on_start_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	#get_tree().change_scene("res://scenes/levels/LVL_0.tscn")
	emit_signal("startgame")

func _on_exit_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("close")

func _on_options_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	settings_menu.popup_centered()

func _on_extras_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	#get_tree().change_scene("res://demo/DemoHero.tscn")
	emit_signal("extra")

func _on_credits_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	#get_tree().change_scene("res://godot-credits-master/GodotCredits.tscn")
	emit_signal("credits")

func load_level():
	var save_file = File.new()
	if not save_file.file_exists("user://savefile.save"):
		level = 0
		return
	save_file.open("user://savefile.save", File.READ)
	level = int(save_file.get_line())
	save_file.close()
