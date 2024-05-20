extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player") #ref to player node
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var interaction_area = $InteractionArea # interaction
@onready var audio_stream_player_2d_eat = $AudioStreamPlayer2D_Eat

@export var speed = 50
@export var nav_agent: NavigationAgent2D

var target_node = null
var home_pos = Vector2.ZERO

var move_direction: Vector2 = Vector2.ZERO

var distance_to_player: float

const MAX_DISTANCE_TO_PLAYER: int = 80 #max distance to player that robot can be to player
const MIN_DISTANCE_TO_PLAYER: int = 40 #min

const WANDER_CIRCLE_RADIUS: int = 8
const WANDER_RANDOMNESS: float = 0.2
var wander_angle: float = 0
@export var wandering: bool = true

func _ready():
	interaction_area.interact = Callable(self, "_eat_fish")
	home_pos = self.global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	
func _eat_fish():	
	Global.fish += 1
	player.audio_stream_player_2d_eat.play() #eats fish when player gets on top 
	
	self.queue_free() #deletes fish
	# TODO: Fish pick up sounds effects TODO

func _physics_process(delta):
	#var steering: Vector2 = Vector2.ZERO
	#
	#if wandering:
		#steering += wander_steering()
	#else:
		if nav_agent.is_navigation_finished():
			_cirlceSpin(1)
			var vector_to_next_point: Vector2 = nav_agent.get_next_path_position() - global_position
			if vector_to_next_point.x > 0 and animated_sprite.flip_h:
				animated_sprite.flip_h = false
			elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
				animated_sprite.flip_h = true
			return
		
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = axis * speed
		
		move_and_slide()
	
func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos

func chase() -> void:
		if not nav_agent.is_target_reached():
			var vector_to_next_point: Vector2 = nav_agent.get_next_path_position() - global_position
			move_direction = vector_to_next_point 
			#move_direction = vector_to_next_point * trackingSpeed
				
			#change sprite based on mouse location
			if vector_to_next_point.x > 0 and animated_sprite.flip_h:
				animated_sprite.flip_h = false
			elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
				animated_sprite.flip_h = true

func _on_path_timer_timeout():
	if is_instance_valid(player):
			distance_to_player = (player.position - global_position).length()
			#if distance_to_player > MAX_DISTANCE_TO_PLAYER:
				#_cirlceSpin(1)
				#wander_steering()
			if distance_to_player < MIN_DISTANCE_TO_PLAYER:
				_get_path_to_move_away_from_player()
				_eat_fish()
							#play player eating animation
	else:
		move_direction = Vector2.ZERO

#move away from player
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	nav_agent.target_position = global_position + dir * 100
	
func _get_path_to_player() -> void:
	nav_agent.target_position = player.position 

#player entered
func _on_area_2d_area_entered(area):
	target_node = area.owner
	
#player exited
func _on_area_2d_2_area_exited(area):
	if area.owner == target_node:
		target_node = null

func wander_steering() -> Vector2:
	wander_angle = randi_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_circle: Vector2 = velocity.normalized() * speed
	var desired_velocity: Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return desired_velocity - vector_to_circle

var d := 0.0
var radius := 5

func _cirlceSpin(delta: float) -> void:
	d += delta
	
	nav_agent.target_position = Vector2(
		sin(d * speed) * radius,
		cos(d * speed) * radius
	) + global_position

