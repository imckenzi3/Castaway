extends CharacterBody2D

@onready var interaction_area = $InteractionArea # interaction

#need to make fish run away from player a little?
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player") #ref to player node

const MAX_DISTANCE_TO_PLAYER: int = 80 #max distance to player that robot can be to player
const MIN_DISTANCE_TO_PLAYER: int = 40 #min

var can_attack: bool = true

var distance_to_player: float

@onready var nav_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func _get_path_to_player() -> void:
	nav_agent.target_position = player.position 
	
	
func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
			
			#if the enemy is not too close or too far away
			#check if can_attack is true

	#else:
		#move_direction = Vector2.ZERO

#move away from player
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	nav_agent.target_position = global_position + dir * 100


func _ready():
	interaction_area.interact = Callable(self, "_eat_fish")

func _eat_fish():
	visible = false
	
