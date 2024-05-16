extends Node2D

#@onready var player = get_tree().get_first_node_in_group("player") #get player
#@onready var player = $Player #get player
#@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player") #ref to player node
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player") #ref to player node
@onready var label = $Label #get label

const base_text = "[E] TO "

var active_areas = [] #hold all interaction areas that can be interacted with
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(delta): #show label that can be interacted with
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name #show label above area
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x / 2
		label.show() #make label visible
	else:
		label.hide() #if no active areas make label invisible
		
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event): #when player press e
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
