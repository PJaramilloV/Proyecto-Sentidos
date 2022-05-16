extends Node2D

onready var back = $Back
var time_in_seconds = 0.2


func _ready():
	back.connect("pressed", self, "_on_back_pressed")


func _on_Back_pressed():
	$AudioStreamPlayer2D.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://scenes/main_menu.tscn")
