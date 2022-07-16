extends OmniLight

onready var noise = OpenSimplexNoise.new()
onready var start = rand_range(0, 180)
onready var audio = get_parent().get_node("AudioStreamPlayer3D")
var value = 0.0

func _ready():
	randomize()
	value = randi() % 100000000
	noise.period = 16
	noise.octaves = 1
	audio.play(start)

func _physics_process(delta):
	value += 1
	var alpha = noise.get_noise_1d(value)*0.5 + 1.3
	light_energy = alpha
