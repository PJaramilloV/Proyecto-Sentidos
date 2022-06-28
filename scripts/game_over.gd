extends Control

onready var menu = $CanvasLayer/menu
onready var exit = $CanvasLayer/exit

signal restart
signal close

var time_in_seconds = 0.2

func _ready():
	menu.connect("pressed", self, "_menu")
	exit.connect("pressed", self, "_exit")
	reset_level()
	yield(get_tree().create_timer(4.0), "timeout")
	$AnimationPlayer.play("fade")
	menu.disabled = false
	exit.disabled = false

func _menu():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("restart")

func _exit():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("close")

func reset_level():
	var save_file = File.new()
	save_file.open("user://savefile.save", File.WRITE)
	save_file.store_line(String(0))
	save_file.close()
