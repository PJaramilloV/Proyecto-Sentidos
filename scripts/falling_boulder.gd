extends Spatial

onready var hitbox = get_node("hitbox")
onready var detector = get_node("area")
onready var particles = get_node("hitbox/Particles")
var process_method = "wait"
var timer = 0.0
export var delay: float
onready var landing_sound = get_node("hitbox/Audio")
onready var scare_sound = get_node("Scare")
onready var warning_sound = get_node("WarningAudio")
var warning_sound_cd = 20.0
var warning_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.mode = RigidBody.MODE_STATIC
	warning_timer = warning_sound_cd

func wait(delta):
	warning_timer -= delta
	if warning_timer <= 0:
		warning_noise()
		warning_timer = warning_sound_cd

func sleep(delta):
	pass

func activating(delta):
	delay -= delta
	if delay < 0:
		activate()

func falling(delta):
	timer += delta
	if timer > 0.4 and abs(hitbox.linear_velocity.y)  < 0.25:
		landing_noise()
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
	falling_noise()
	hitbox.mode = RigidBody.MODE_RIGID
	hitbox.connect("body_entered", self, "_on_body_collided")
	process_method = "falling"

func warning_noise():
	if warning_sound:
		var children = warning_sound.get_children()
		children[randi() % children.size()].play()

func falling_noise():
	if scare_sound:
		var children = scare_sound.get_children()
		children[randi() % children.size()].play()
		$Drop.play()

func landing_noise():
	if landing_sound:
		for sound in landing_sound.get_children():
			if sound.name == "1":
				sound.play(1)
			else:
				sound.play()
		particles.emitting = true
