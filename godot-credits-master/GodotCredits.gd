extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 5.0
const title_color := Color.chartreuse

var scroll_speed := base_speed
var speed_up := false 
var speed_pause := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

#var time_in_seconds = 3
var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

# I know, no es muy bonito el display de esta variable
var credits = [
	[
		"A game by Bacan Studios"
	],[
		"Programming",
		" ",
		" ",
		"Rodrigo Iturrieta",
		" ",
		" ",
		"Pablo Jaramillo",
		" ",
		" ",
		"Vicente González",
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
		'Wojciech Kalinowski "wmk69"',
		" ",
		" ",
		"SIL Open Font License (OFL)",
		" ",
		" ",
		"fontlibrary.org"
	],[
		"Sound Effects",
		" ",
		" ",
		"Main Menu Button Sound",
		" ",
		" ",
		'"Button Sound 24"',
		" ",
		" ",
		"Sound Jay",
		" ",
		" ",
		"www.soundjay.com",
		" ",
		" ",
		"Enviromental sounds, music and others",
		" ",
		" ",
		"Zapsplat",
		" ",
		" ",
		"Standard License",
		" ",
		" ",
		"https://www.zapsplat.com"
	],[
		"3D Models",
		" ",
		" ",
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
		" ",
		" ",
		"World's Asset Pack",
		" ",
		" ",
		'"Modular Terrain Pack"',
		" ",
		" ",
		"Keith at Fertile Soil Productions",
		" ",
		"https://fertile-soil-productions.itch.io",
		" ",
		" ",
		"Main Character Model",
		" ",
		" ",
		'"Free Low Poly Male Base Mesh"',
		" ",
		" ",
		"kristenlee",
		" ",
		" ",
		"https://sketchfab.com/kristenlee",
		" ",
		" ",
		"Copyright (c) 2021",
		" ",
		" ",
		"Creative Commons Attribution 4.0 International License (CC BY 4.0)",
		" ",
		" ",
		"This work was modified by Bacan Studios",
		" ",
		" ",
		"Character 3D Animations",
		" ",
		" ",
		"Mixamo"
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
		"https://github.com/benbishopnz",
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
		'"Day to Day Life" from Recurrence Theorem (2016)',
		" ",
		" ",
		"Written by Benjamín Vera",
		" ",
		" ",
		"Produced by Fabián Estrella, Florencia Morera, Joana Dekker and Benjamín Vera",
		" ",
		" ",
		"Benja Vera on Soundcloud: https://soundcloud.com/benja-vald-s-71326544"
	],[
		"Testers",
		" ",
		" ",
		"Name"
	],[
		"Art",
		" ",
		" ",
		"Name"
	],[
		"Special Thanks",
		" ",
		" ",
		"Name"
	],[
		"Tools used",
		" ",
		" ",
		"Developed with Godot Engine",
		" ",
		" ",
		"https://godotengine.org/license",
		" ",
		" ",
	],[
		"Curso",
		" ",
		" ",
		"Taller de Diseño y Desarrollo de Videojuegos",
		" ",
		" ",
		"CC5408-1",
	],[
		"Profesor",
		" ",
		" ",
		"Elías Zelada"
	],[
		"Ayudantes",
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



func _process(delta):
	var scroll_speed = base_speed * delta
	if speed_pause or finished:
		scroll_speed *= 0
		$CreditsContainer/Line/Sprite_3.visible = false
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
			for l in lines:
				l.rect_position.y -= scroll_speed
#				if l.rect_position.y < -l.get_line_height():
#					lines.erase(l)
#					l.queue_free()

func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	
	#### Videos ####
	if new_line.text == "Art":
		$CreditsContainer/Line/VideoPlayer_1.visible = true
		$CreditsContainer/Line/VideoPlayer_1.paused = false
	if new_line.text == " ":
		$CreditsContainer/Line/VideoPlayer_1.visible = false
		$CreditsContainer/Line/VideoPlayer_1.paused = true	
		
	if new_line.text == "Tools used":
		$CreditsContainer/Line/VideoPlayer_2.visible = true
		$CreditsContainer/Line/VideoPlayer_2.paused = false
	if new_line.text == " ":
		$CreditsContainer/Line/VideoPlayer_2.visible = false
		$CreditsContainer/Line/VideoPlayer_2.paused = true	

	#### Fotos ####
	if new_line.text == "A game by Bacan Studios":
		$CreditsContainer/Line/Profundis.visible = true
	if new_line.text == "Programming":
		$CreditsContainer/Line/Profundis.visible = false
		
	if new_line.text == "Programming":
		$CreditsContainer/Line/Sprite_1.visible = true
	if new_line.text == " ":
		$CreditsContainer/Line/Sprite_1.visible = false
		
	if new_line.text == "Profesor":
		$CreditsContainer/Line/Sprite_2.visible = true
	if new_line.text == " ":
		$CreditsContainer/Line/Sprite_2.visible = false
		
	if new_line.text == "Damián Ibarra Z.":
		$CreditsContainer/Line/Sprite_3.visible = true
	if new_line.text == " ":
		$CreditsContainer/Line/Sprite_3.visible = false

	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
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
