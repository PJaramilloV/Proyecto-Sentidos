extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 5.0
const title_color := Color.chartreuse

var scroll_speed := base_speed
var speed_up := false 
var speed_pause := false

onready var menu = $menu
onready var exit = $exit
onready var line := $CreditsContainer/Line
var started := false
var finished := false

signal restart
signal close

#var time_in_seconds = 3
var time_in_seconds = 0.2
var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

onready var profundis = $visuals/Profundis

# Imagenes y videos


onready var dinner = $visuals/Dinner
onready var logo = $visuals/Logo
onready var level_5 = $visuals/level_5
onready var amogus = $visuals/amogus

onready var moonwalk = $visuals/Moonwalk
onready var ladder = $visuals/Ladder
onready var baile_1 = $visuals/baile_1
onready var baile_2 = $visuals/baile_2


# I know, no es muy bonito el display de esta variable
var credits = [
	[
		"A game by Bacan Studios"
	],[
		"Programming",
		" ",
		" ",
		"Vicente González",
		" ",
		" ",
		"Rodrigo Iturrieta",
		" ",
		" ",
		"Pablo Jaramillo",
		" ",
		" ",
		"Diego Torreblanca"
	],[
		"Original Idea",
		" ",
		" ",
		"Vicente González"
	],[
		"Font",
		" ",
		" ",
		'"Medieval Sharp Book"',
		" ",
		" ",
		'"Medieval Sharp Book Oblique"',
		" ",
		" ",
		'Wojciech Kalinowski "wmk69"',
		" ",
		" ",
		"SIL Open Font License (OFL)",
		" ",
		" ",
		"fontlibrary.org"
	],[
		"Sound Effects"
	],[
		"Main Menu Button Sound",
		" ",
		" ",
		'"Button Sound 24"',
		" ",
		" ",
		"Sound Jay",
		" ",
		" ",
		"soundjay.com"
	],[
		"Enviromental sounds, music and others",
		" ",
		" ",
		"Zapsplat",
		" ",
		" ",
		"Standard License",
		" ",
		" ",
		"zapsplat.com"
	],[
		"3D Models",
	],[
		"Object's Asset Pack",
		" ",
		" ",
		'"Ultimate Low Poly Dungeon"',
		" ",
		" ",
		"Broken Vector",
		" ",
		" ",
		"MIT License",
		" ",
		" ",
		"Copytight (c) 2022",
		" ",
		" ",
		"Creative Commons Attribution 4.0 International License (CC BY 4.0)",
	],[
		"World's Asset Pack",
		" ",
		" ",
		'"Modular Terrain Pack"',
		" ",
		" ",
		"Keith at Fertile Soil Productions",
		" ",
		"fertile-soil-productions.itch.io",
	],[
		"Main Character Model",
		" ",
		" ",
		'"Free Low Poly Male Base Mesh"',
		" ",
		" ",
		"kristenlee",
		" ",
		" ",
		"sketchfab.com/kristenlee",
		" ",
		" ",
		"Copyright (c) 2021",
		" ",
		" ",
		"Creative Commons Attribution 4.0 International License (CC BY 4.0)",
		" ",
		" ",
		"This work was modified by Bacan Studios",
	],[
		"Character 3D Animations",
		" ",
		" ",
		"Mixamo",
		" ",
		" ",
		"mixamo.com"
	],[
		"Credits",
		" ",
		" ",
		"Credits Scene and Script Model",
		" ",
		" ",
		'"godot-credits"',
		" ",
		" ",
		"Ben Bishop",
		" ",
		" ",
		"github.com/benbishopnz",
		" ",
		" ",
		"MIT License",
		" ",
		" ",
		"This work was modified by Bacan Studios"
	],[
		"Music",
		" ",
		" ",
		'"Lonely Mountain"',
		" ",
		" ",
		"Written by Rafael Krux",
		" ",
		" ",
		"freepd.com/epic.php",
		" ",
		" ",
		"CC0 1.0 Universal License (CC0 1.0)",
		" ",
		" ",
		" ",
		" ",
		'“Dungeon Air” Uploaded by Flamiffer ',
		" ",
		" ",
		'"cavernscape" Uploaded by blaukreuz',
		" ",
		" ",
		'"ambient noise" Uploaded by patchytherat',
		" ",
		" ",
		"Music from Pixabay (Pixabay.com)",
		" ",
		" ",
		"Pixabay License",
		" ",
		" ",
		" ",
		" ",
		'"Day to Day Life" from Recurrence Theorem (2016)',
		" ",
		" ",
		"Written by Benjamín Vera",
		" ",
		" ",
		"Produced by Fabián Estrella, Florencia Morera, Joana Dekker and Benjamín Vera",
		" ",
		" ",
		"Benja Vera on Soundcloud:",
		" ",
		" ",
		"soundcloud.com/benja-vald-s-71326544"
	],[
		"Tester",
		" ",
		" ",
		"Diego Iturrieta"
	],[
		"Special Thanks",
		" ",
		" ",
		"Damián Ibarra Z.",
		" ",
		" ",
		"Benjamín Vera",
		" ",
		" ",
		"Godot Community"
	],[
		"Tools used",
		" ",
		" ",
		"Developed with Godot Engine",
		" ",
		" ",
		"godotengine.org/license",
		" ",
		" ",
	],[
		"Course",
		" ",
		" ",
		"Taller de Diseño y Desarrollo de Videojuegos",
		" ",
		" ",
		"CC5408-1",
	],[
		"Professor",
		" ",
		" ",
		"Elías Zelada"
	],[
		"Professor’s Assistants",
		" ",
		" ",
		"Christopher Marín R.",
		" ",
		" ",
		"Damián Ibarra Z.",
		" ",
		" ",
		"Gabriel G. Orrego"
	]
]

func _ready():
	menu.connect("pressed", self, "_menu")
	exit.connect("pressed", self, "_exit")

func _process(delta):
	var scroll_speed = base_speed * delta
	if speed_pause or finished:
		scroll_speed *= 0

	else:
		if section_next:
			section_timer += delta * speed_up_multiplier if speed_up else delta
			if section_timer >= section_time:
				section_timer -= section_time
				
				if credits.size() > 0:
					started = true
					section = credits.pop_front()
					curr_line = 0
					add_line()
		else:
			line_timer += delta * speed_up_multiplier if speed_up else delta
			if line_timer >= line_time:
				line_timer -= line_time
				add_line()
		
		if speed_up:
			scroll_speed *= speed_up_multiplier

		if lines.size() > 0:
			if lines[-1].text == "Gabriel G. Orrego":

				if lines[-1].rect_position.y<-100 and !finished:
					finished = true
					scroll_speed *= 0
					$AnimationPlayer.play("fade")
					menu.disabled = false
					exit.disabled = false
			for l in lines:
				l.rect_position.y -= scroll_speed
				if (l.rect_position.y +500 < -l.get_line_height()) and !finished:
					lines.erase(l)
					l.queue_free()

func add_line():
	var new_line = line.duplicate()
	var child
	
	new_line.text = section.pop_front()
	
	# Label titulo
	if new_line.text == "A game by Bacan Studios":
		child = profundis
		child.rect_position.y -= profundis.rect_position.y + 418.5	
		profundis.visible = true
		$visuals.remove_child(profundis)
		
	
	#### Videos ####
	
	# Moonwalk
	if new_line.text == "Original Idea":
		child = moonwalk
		child.rect_position.y -= moonwalk.rect_position.y + 200
		moonwalk.visible = true
		moonwalk.paused = false
		$visuals.remove_child(moonwalk)
	
	# Hover escalera
	if new_line.text == "Sound Effects":
		child = ladder
		child.rect_position.y -= ladder.rect_position.y + 250
		ladder.visible = true
		ladder.paused = false
		$visuals.remove_child(ladder)

	# Baile 1
	if new_line.text == "Programming":
		child = baile_1
		child.rect_position.y -= baile_1.rect_position.y + 250
		baile_1.visible = true
		baile_1.paused = false
		$visuals.remove_child(baile_1)

	# Baile 2
	if new_line.text == "Object's Asset Pack":
		child = baile_2
		child.rect_position.y -= baile_2.rect_position.y + 250
		baile_2.visible = true
		baile_2.paused = false
		$visuals.remove_child(baile_2)


	#### Fotos ####
	
	# Cena
	if new_line.text == "Tools used":
		child = dinner
		child.position.y -= dinner.position.y + 250
		dinner.visible = true
		$visuals.remove_child(dinner)
	
	# Dibujo level 5
	if new_line.text == "Mixamo":
		child = level_5
		child.position.y -= level_5.position.y
		level_5.visible = true
		$visuals.remove_child(level_5)
	
	# Amogus
	if new_line.text == "Professor’s Assistants":
		child = amogus
		child.position.y -= amogus.position.y 
		amogus.visible = true
		$visuals.remove_child(amogus)

	# Logo bacan studios
	if new_line.text == "Christopher Marín R.":
		child = logo
		child.position.y -= logo.position.y -750
		logo.visible = true
		$visuals.remove_child(logo)


	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if child:
		new_line.add_child(child)
	
	lines.append(new_line)
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
	if event.is_action_pressed("ui_accept"):
		speed_pause = !speed_pause

func _menu():
	$AudioStreamPlayer2D2.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("restart")

func _exit():
	$AudioStreamPlayer2D2.play()
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("close")
