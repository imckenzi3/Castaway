extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player") #ref to player node
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

@export var speed = 50
@export var nav_agent: NavigationAgent2D

var target_node = null
var home_pos = Vector2.ZERO

var move_direction: Vector2 = Vector2.ZERO

var distance_to_player: float

const MAX_DISTANCE_TO_PLAYER: int = 80 #max distance to player that robot can be to player
const MIN_DISTANCE_TO_PLAYER: int = 40 #min

@onready var hitbox: Area2D = get_node("Hitbox") #var for hitbox

var randomNum
var target

enum {
	SURROUND,
	ATTACK
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomNum = rng.randf()
	
	home_pos = self.global_position
	
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	

func _physics_process(delta):
	match state:
		SURROUND:
			move(get_circle_position(randomNum), delta)
			
	hitbox.knockback_direction = velocity.normalized() #knock back
	
	if nav_agent.is_navigation_finished():
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
			
func move(target, delta) -> void:
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering

func _on_path_timer_timeout():
	if is_instance_valid(player):
			distance_to_player = (player.position - global_position).length()
			if distance_to_player > MAX_DISTANCE_TO_PLAYER:
				_get_path_to_player()
	else:
		get_circle_position(randomNum)
	
func _get_path_to_player() -> void: 
	nav_agent.target_position = player.position #path to player

func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;
	
	return Vector2(x,y)
