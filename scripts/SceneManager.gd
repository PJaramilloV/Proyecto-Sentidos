extends Node2D

const main_menu = preload("res://scenes/main_menu.tscn")
const demo = preload("res://demo/DemoHero.tscn")
const level0 = preload("res://scenes/levels/LVL_0.tscn")
const level1 = preload("res://scenes/levels/LVL_1.tscn")
const level2 = preload("res://scenes/levels/LVL_2.tscn")
const level3 = preload("res://scenes/levels/LVL_3.tscn")
const level4 = preload("res://scenes/levels/LVL_4.tscn")
const level5 = preload("res://scenes/levels/LVL_5.tscn")
var levels = [level0, level1, level2, level3, level4, level5]
var temp_level
#onready var pointer = $CurrentScene/Control.level
var pointer

func _ready():
	$CurrentScene.add_child(main_menu.instance())
	pointer = $CurrentScene/Control.level
	$CurrentScene/Control.connect("startgame", self, "_start_game")
	$CurrentScene/Control.connect("continuegame", self, "_on_Control_continuegame")
	$CurrentScene/Control.connect("extra", self, "_extra")

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		$TransitionScreen.transition()

func _start_game():
	$TransitionScreen.transition_to_level_0()

func _on_Control_continuegame(level):
	temp_level = level
	$TransitionScreen.transition_continue()

func _extra():
	$TransitionScreen.transition_extra()

func _on_TransitionScreen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(level2.instance())
	print("Swapped in SceneTwo")

func _on_TransitionScreen_main_menu():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(main_menu.instance())
	pointer = $CurrentScene/Control.level
#	$CurrentScene/Control.connect("startgame", self, "_start_game")
#	$CurrentScene/Control.connect("continuegame", self, "_on_Control_continuegame")

func _on_TransitionScreen_next_level():
	pointer += 1
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(levels[pointer].instance())

func _on_TransitionScreen_game_over():
	pass # Replace with function body.

func _on_TransitionScreen_level_0():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(level0.instance())

func _on_TransitionScreen_continuen():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(levels[temp_level].instance())

func _on_TransitionScreen_extra():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(demo.instance())
