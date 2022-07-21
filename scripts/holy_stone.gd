extends Spatial

onready var top = get_node("top")
onready var low = get_node("low")
onready var core = get_node("core")
onready var omni = get_node("omni")
onready var ray = get_node("ray")
onready var area = get_node("detector")
onready var stone_sound = get_node("stone_sound")
var process_function = "sleep"
var timer  = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "activate")

# Hacer nada
func sleep(delta):
	pass

# Initiating windows
func activating(delta):
	timer += delta
	var s_scale = 1 + 7 * timer
	var top_destination  =  Vector3(0, timer*0.3455,   0)
	var top_rotation =  Vector3(0, 45*(1-timer),   0)
	var core_translation =  Vector3(0, 0.1065*(timer), 0)
	var core_size_scale  = Vector3(s_scale, s_scale, s_scale)
	var low_destination  =  Vector3(0, 0.102*timer,    0)
	var low_rotation =  top.rotation_degrees * 2
	var speed = exp(randf()) *1.2
	top.translation = lerp(top.translation, top_destination, speed)
	top.rotation_degrees = lerp(top.rotation_degrees, top_rotation, speed)
	core.scale = lerp(core.scale, core_size_scale, speed)
	core.translation = lerp(core.translation, core_translation, speed)
	low.translation = lerp(low.translation, low_destination, speed)
	low.rotation_degrees = lerp(low.rotation_degrees, low_rotation, speed)
	ray.scale = lerp(ray.scale, Vector3(1,0.475*timer, 1), 10*delta)
	if(timer > 2):
		process_function = "active"
		omni.light_energy = lerp(omni.light_energy, 2.804, 2*delta)
		omni.light_specular = lerp(omni.light_specular, 2.66, 2*delta)
		return
	omni.light_energy = randf()
	omni.light_specular = randf()

# Permament animation
func active(delta):
	timer += delta
	var s_scale = 15 + sin(3*timer)
	var speed = 2*delta
	var top_destination  = Vector3(0, 0.15*(sin(timer)) + 0.691,   0)
	var top_rotation =  Vector3(0, 45*(1-timer),   0)
	var core_size_scale  = Vector3(s_scale, 15 + cos(3*timer), s_scale)
	var low_destination  =  Vector3(0, 0.102*cos(timer) + 0.204,    0)
	var low_rotation =  Vector3(0, 45*(timer-1),   0)
	top.translation = lerp(top.translation, top_destination, speed)
	top.rotation_degrees = lerp(top.rotation_degrees, top_rotation, speed)
	core.scale = lerp(core.scale, core_size_scale, speed)
	low.translation = lerp(low.translation, low_destination, speed)
	low.rotation_degrees = lerp(low.rotation_degrees, low_rotation, speed)
	omni.light_energy = lerp(omni.light_energy, 2.304 + 1.5*cos(timer), 2*delta)
	omni.light_specular = lerp(omni.light_specular, 2.16+ 1.5*sin(timer), 2*delta)
	ray.rotation_degrees = lerp(ray.rotation_degrees, Vector3(randf(), 90*timer, randf()), speed)
	var emission = 0.35*(1-sin(3*timer))
	top.get_node("Mesh").mesh.surface_get_material(0).emission_energy = emission
	low.get_node("Mesh").mesh.surface_get_material(0).emission_energy = emission
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	call(process_function, delta) # llamar process_function(delta)

# Llamar para activar animacion
func activate(player: Node):
	stone_sound.play()
	process_function = "activating"
	area.disconnect("body_entered", self, "activate")

func _on_CutsceneActivator2_ended():
	stone_sound.play()
	process_function = "activating"
	area.disconnect("body_entered", self, "activate")
