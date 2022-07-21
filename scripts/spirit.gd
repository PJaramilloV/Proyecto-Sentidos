extends Spatial

onready var target: Object = get_parent().get_node("hero/CollisionShape/behind")
onready var omni: OmniLight = get_node("OmniLight")
onready var animation: AnimationPlayer = get_node("AnimationPlayer")
export var smooth_speed := 2
export var offset: Vector3
var flash_t := 0.0
var angle := 0.0
	
func _physics_process(delta) -> void:
	#print(target.global_transform.origin)
	#print(self.global_transform.origin)
	if(target != null):
		angle += delta * 2
		var destination = target.global_transform.origin + offset + Vector3(0.0, 0.2*sin(angle),0.0 )
		self.global_transform.origin = lerp(self.global_transform.origin, destination, smooth_speed * delta)
	
	if(flash_t > 0):					#    \/ coeficientes obtenidos por algebra
		omni.set_param(0, 1.665 + flash_t*14.85)  # Set energy (param 0)
		omni.set_param(5, 17.1 - flash_t*21.66)   # Set attenuation (param 5)
		# attenuation: 17.1  (default)  1.27 (peak flash)
		# energy	 : 1.665 (default)  9.09 (peak flash)
		flash_t -= delta
		


func flash():
	self.flash_t = 0.5

func reset():
	angle = 0.0
	var destination = target.global_transform.origin + offset + Vector3(0.0, 0.2*sin(angle),0.0 )
	self.global_transform.origin = destination

func say(text):
	get_node("Sprite3D/Viewport/Label").text = text
	animation.play("show")
