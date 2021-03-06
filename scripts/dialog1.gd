extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file #Recuperar el .json, creo
export(float) var textSpeed = 0.04 #Velocidad en que aparecen los caracteres

var dialogues = []
var current_dialogue_id = 0
var started = false
var finished = false
var ended = false
var contador = 3

onready var box = $NinePatchRect
onready var nom_personaje = $NinePatchRect/Name
onready var mensaje = $NinePatchRect/Message
onready var triangulo = $NinePatchRect/Polygon2D

func _ready():
	$Timer.wait_time = textSpeed
	$NinePatchRect/Polygon2D/AnimationPlayer.play("idle")
	#play()

func play():
	box.visible = true
	dialogues = load_dialogue()
	current_dialogue_id = -1 # Para partir desde el índice 0 cuando llame la funcion
	next_line()

func _input(event):
	if event.is_action_pressed("interact") and started: #Apretar la tecla E
		if finished: #Si ya se mostró todo el texto correspondiente el indice
			next_line()
		else:
			mensaje.visible_characters = len(mensaje.text) #Autocompletar el resto del texto

func next_line():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogues): #Cuando ya se terminó el texto
		box.visible = false
		ended = true
		return
	
	finished = false
	triangulo.visible = finished #Ocultar el triangulo
	
	nom_personaje.bbcode_text = dialogues[current_dialogue_id]["name"] #Recuperar el nombre del personaje
	mensaje.bbcode_text = dialogues[current_dialogue_id]["text"] #Recuperar el mensaje

	mensaje.visible_characters = 0
	
	#Mostrar caracteres de uno en uno segun el tiempo del Timer
	while mensaje.visible_characters < len(mensaje.text):
		mensaje.visible_characters += 1
		contador += 1
		if contador % 4 == 0:
			$text_sound.play()
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	triangulo.visible = finished #Mostrar el traingulo

func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
