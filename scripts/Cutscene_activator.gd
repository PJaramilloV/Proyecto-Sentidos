extends VisibilityNotifier
export var radius : float
export var active : bool
var pos : Vector3
onready var player = get_parent().get_node("Player")

func _ready():
	pos = global_transform.origin

func _on_CutsceneActivator_screen_entered():
	if active:
		player.cutscene(pos, radius)
		active = false
