extends Spatial

export var lives := 5
export var startwithspirit : bool
export var startonfloor : bool
export var throw : bool
export var brace : bool

onready var spiritmesh = get_node("spirit/MeshInstance")
onready var spiritlight = get_node("spirit/OmniLight")
onready var spiritcilinder = get_node("spirit/aura")
onready var hero = get_node("hero")
onready var statemachine = get_node("hero/StateMachine")

onready var daudio1 = $Audio/Death/death1
onready var daudio2 = $Audio/Death/death2
onready var daudio3 = $Audio/Death/death3
onready var daudio4 = $Audio/Death/death4
onready var deatharray = [daudio4, daudio3, daudio2, daudio1]

signal death

# a = (22 y 125)
var _colors1 = [Color(0.894118, 0.062745, 0, 0.490196), Color(0.752941, 0.403922, 0, 0.490196), Color(0.768627, 0.701961, 0, 0.490196), Color(0.619608, 0.784314, 0.023529, 0.490196), Color(0.894118, 0.062745, 0, 0.490196)]
#var _colors1 = [Color.red,Color.red,Color.red,Color.red,Color.red]
var _colors2 = [Color(0.894118, 0.062745, 0, 0.086275), Color(0.752941, 0.403922, 0, 0.086275), Color(0.768627, 0.701961, 0, 0.086275), Color(0.619608, 0.784314, 0.023529, 0.086275), Color(0.345098, 0.847059, 0.031373, 0.086275)]
var _colors = [Color(0.894118, 0.062745, 0), Color(0.752941, 0.403922, 0), Color(0.768627, 0.690196, 0), Color(0.619608, 0.784314, 0.023529), Color(0.345098, 0.847059, 0.031373)]

func _ready():
	var mat1 = spiritmesh.mesh.surface_get_material(0)
	var mat2 = spiritcilinder.mesh.surface_get_material(0)
	mat1.albedo_color = _colors1[lives-1]
	mat1.emission = _colors[lives-1]
	mat2.albedo_color = _colors2[lives-1]
	spiritlight.light_color = _colors[lives-1]
	#spiritlight.light_color = Color(255, 126 ,0)
	# Color(255, 126 ,0)
	#print(spiritlight.light_color)
	if !startwithspirit:
		get_node("spirit").visible = false
	### Definir el estado inicial ###
	if startonfloor:
		statemachine.transition_to("Wakeup")
	hero._brace = brace
	if throw:
		hero.learn_throw()

func death():
	lives -= 1
	if lives == 0:
		emit_signal("death")
		return false
	if 0 <= (lives-1) and (lives-1) < 5:
		var mat1 = spiritmesh.mesh.surface_get_material(0)
		var mat2 = spiritcilinder.mesh.surface_get_material(0)
		mat1.albedo_color = _colors1[lives-1]
		mat1.emission = _colors[lives-1]
		mat2.albedo_color = _colors2[lives-1]
		spiritlight.light_color = _colors[lives-1]
		deatharray[lives-1].play()
	return true

func spirit():
	get_node("spirit").visible = true

# Activación de Cutscene
func cutscene(pos: Vector3, radius: float):
	statemachine.transition_to("Cutscene")
	hero.move_to(pos, radius)
