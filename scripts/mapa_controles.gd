extends Node2D

onready var back = $Back

func _ready():
	back.connect("pressed", self, "_on_back_pressed")




func _on_Back_pressed():
	get_tree().change_scene("res://scenes/main_menu.tscn")
