extends VisibilityNotifier
export var radius : float
export var active : bool
export var dialogue_start_timer := 1.0
onready var dialogue := get_node("dialogue")
var pos : Vector3
onready var player = get_parent().get_node("Player")
onready var hero = player.get_node("hero")
onready var screen = get_node_or_null("TransitionScreen")
var dialogue_ended := false

func _ready():
	pos = global_transform.origin
	dialogue.started = true

func _physics_process(delta):
	if dialogue.ended and !dialogue_ended:
		dialogue_ended = true
#		player.spirit()
#		hero.end_cutscene()
		if screen:
			screen.transition()
		else:
			player.spirit()
			hero.end_cutscene()

func _on_CutsceneActivator_screen_entered():
	if active:
		player.cutscene(pos, radius)
		active = false

func start_dialogue():
	yield(get_tree().create_timer(dialogue_start_timer), "timeout")
	dialogue.started = true
	dialogue.play()

func _on_Area_body_entered(body):
	if !dialogue_ended:
		start_dialogue()

func _on_TransitionScreen_transitioned():
	player.spirit()
	hero.end_cutscene()
