extends VisibilityNotifier
export var radius : float
export var active : bool
export var dialogue_start_timer := 1.0
export var unlock_spirit := false
export var unlock_throw := false
export var unlock_brace := false
export var connect := false
export var disable_spirit := false
export var trigger_finish := false
onready var dialogue := get_node("dialogue")
var pos : Vector3
onready var player = get_parent().get_node("Player")
onready var hero = player.get_node("hero")
onready var screen = get_node_or_null("TransitionScreen")
var dialogue_ended := false
var controlled_enter := false

signal ended
signal finish

func _ready():
	pos = global_transform.origin
	dialogue.started = true

func _physics_process(delta):
	if dialogue.ended and !dialogue_ended:
		dialogue_ended = true
#		player.spirit()
#		hero.end_cutscene()
		if screen:
			if connect:
				emit_signal("ended")
				screen.flashbang_dialogue()
				if unlock_spirit:
					player.spirit(true)
					player.learn_footstep()
				if disable_spirit:
					player.spirit(false)
			else:
				screen.transition()
		else:
			#player.spirit()
			#player.learn_footstep()
			emit_signal("ended")
			if unlock_throw:
				player.learn_throw()
			if unlock_brace:
				player.learn_brace()
			if trigger_finish:
				emit_signal("finish")
				return
			if !connect:
				hero.end_cutscene()

func _on_CutsceneActivator_screen_entered():
	if active:
		player.cutscene(pos, radius)
		active = false
		controlled_enter = true

func start_dialogue():
	yield(get_tree().create_timer(dialogue_start_timer), "timeout")
	dialogue.started = true
	dialogue.play()

func _on_Area_body_entered(body):
	if !dialogue_ended:
		if !controlled_enter:
			player.cutscene_nomove()
		start_dialogue()

func _on_TransitionScreen_transitioned():
	if unlock_spirit:
		player.spirit(true)
		player.learn_footstep()
	hero.end_cutscene()

func _on_boulder_lethal_kill():
	player.cutscene_nomove()
	start_dialogue()

func _on_TransitionScreen_flashbang():
	if !dialogue_ended:
		start_dialogue()

func _on_CutsceneActivator1_ended():
	player.cutscene(pos, radius)
