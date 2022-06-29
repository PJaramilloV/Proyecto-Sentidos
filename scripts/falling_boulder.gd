extends Spatial

onready var hitbox = get_node("hitbox")
onready var detector = get_node("area")
var process_method = "sleep"
var timer = 0.0
export var delay: float


# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.mode = RigidBody.MODE_STATIC

func sleep(delta):
	pass

func activating(delta):
	delay -= delta
	if delay < 0:
		activate()

func falling(delta):
	timer += delta
	if timer > 1.3 and abs(hitbox.linear_velocity.y)  < 0.001:
		hitbox.mode = RigidBody.MODE_STATIC
		hitbox.disconnect("body_entered", self, "_on_body_collided")
		process_method = "sleep"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	call(process_method, delta)

# Vigilar para una colision con el jugador
func _on_body_collided(player: Node):
	if(player.get_collision_layer() == 18):
		player.death()

# Iniciar caida si se detecta un jugador
func _on_area_entered(player: Node):
	# apagar deteccion de jugador
	detector.disconnect("body_entered", self, "_on_area_entered")
	# cambio de metodo de frame a frame
	process_method = "activating"

func activate():
	hitbox.mode = RigidBody.MODE_RIGID
	hitbox.connect("body_entered", self, "_on_body_collided")
	process_method = "falling"
