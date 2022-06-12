extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file
export(float) var textSpeed = 0.05

var dialogues = []
var current_dialogue_id = 0
var finished = false

func _ready():
	$Timer.wait_time = textSpeed
	play()

func play():
	dialogues = load_dialogue()
	current_dialogue_id = -1
	next_line()


func _input(event):
	if event.is_action_pressed("interact"):
		if finished:
			next_line()
		else:
			$NinePatchRect/Message.visible_characters = len($NinePatchRect/Message.text)

func next_line():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogues):
		return
	
	finished = false
	$NinePatchRect/Polygon2D.visible = finished
	
	$NinePatchRect/Name.bbcode_text = dialogues[current_dialogue_id]["name"]
	$NinePatchRect/Message.bbcode_text = dialogues[current_dialogue_id]["text"]

	$NinePatchRect/Message.visible_characters = 0
	
	
	while $NinePatchRect/Message.visible_characters < len($NinePatchRect/Message.text):
		$NinePatchRect/Message.visible_characters += 1
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	$NinePatchRect/Polygon2D.visible = finished
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
