extends Node2D

const main_menu = preload("res://scenes/main_menu.tscn")
const demo = preload("res://demo/DemoHero.tscn")
const game_over = preload("res://scenes/game_over.tscn")
const credits = preload("res://godot-credits-master/GodotCredits.tscn")
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
	reconnect_menu()

func _process(delta):
#	if Input.is_action_just_pressed("interact"):
#		#_death()
#		pointer = 1
#		_to_next_level()
	pass

func _start_game():
	pointer = 0
	$TransitionScreen.transition_to_level_0()

func _to_menu():
	$TransitionScreen.transition_to_menu()

func _to_next_level():
	$TransitionScreen.transition_next_level()

func reconnect():
	$CurrentScene.get_child(0).get_node("PauseMenu").connect("to_menu", self, "_to_menu")
	$CurrentScene.get_child(0).get_node("Player").connect("death", self, "_death")
	if $CurrentScene.get_child(0).get_node("NextLevelArea"):
		$CurrentScene.get_child(0).get_node("NextLevelArea").connect("to_next_level", self, "_to_next_level")
#	for _i in $CurrentScene.get_child(0).get_children():
#		print(_i)

func reconnect_menu():
	$CurrentScene/Control.connect("startgame", self, "_start_game")
	$CurrentScene/Control.connect("continuegame", self, "_continuegame")
	$CurrentScene/Control.connect("extra", self, "_extra")
	$CurrentScene/Control.connect("close", self, "_close")
	$CurrentScene/Control.connect("credits", self, "_credits")

func _extra():
	$TransitionScreen.transition_extra()

func _close():
	$TransitionScreen.transition_close()

func _death():
	$TransitionScreen.transition_lose()

func _credits():
	$TransitionScreen.transition_credits()

func _continuegame(level):
	temp_level = level
	$TransitionScreen.transition_continue()

func _on_TransitionScreen_transitioned():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(level2.instance())
	#print("Swapped in SceneTwo")

func _on_TransitionScreen_main_menu():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(main_menu.instance())
	pointer = $CurrentScene/Control.level
	reconnect_menu()

func _on_TransitionScreen_next_level():
	pointer += 1
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(levels[pointer].instance())
	reconnect()

func _on_TransitionScreen_game_over():
	pass # Replace with function body.

func _on_TransitionScreen_level_0():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(level0.instance())
	reconnect()

func _on_TransitionScreen_continuen():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(levels[temp_level].instance())
	reconnect()

func _on_TransitionScreen_extra():
	#$CurrentScene.get_child(0).queue_free()
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(demo.instance())
	reconnect()

func _on_TransitionScreen_close():
	get_tree().quit()

func _on_TransitionScreen_lose():
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(game_over.instance())
	$CurrentScene/Control.connect("restart", self, "_to_menu")
	$CurrentScene/Control.connect("close", self, "_close")


func _on_TransitionScreen_credits():
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$CurrentScene.add_child(credits.instance())
	$CurrentScene/GodotCredits.connect("restart", self, "_to_menu")
	$CurrentScene/GodotCredits.connect("close", self, "_close")
