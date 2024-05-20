extends CharacterBody2D

@export var speed = 100
@export var accel = 10

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var Trail_Position: Node2D = get_node("TrailPosition")
const WATER_TRAIL_SCENE: PackedScene = preload("res://scenes/water_trail.tscn")
@onready var parent: Node2D = get_parent()
@onready var state_machine: Node = get_node("FiniteStateMachine")
@onready var audio_stream_player_2d_hurt = $AudioStreamPlayer2D_Hurt
@onready var audio_stream_player_2d_dead = $AudioStreamPlayer2D_Dead
@onready var audio_stream_player_2d_eat = $AudioStreamPlayer2D_Eat

@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

var click_position = Vector2()
var target_position = Vector2()

func _ready() -> void:
	click_position = Vector2(0,0)
	
func _physics_process(_delta: float) -> void:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		velocity.x = move_toward(velocity.x, speed * direction.x, accel) 
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		
		if velocity.x > 0 and anim_sprite.flip_h:
			anim_sprite.flip_h = false
		elif velocity.x < 0 and not anim_sprite.flip_h:
			anim_sprite.flip_h = true
		_eat_fish()
		move_and_slide()

func spawn_water() ->void:
	var water: Sprite2D = WATER_TRAIL_SCENE.instantiate()
	water.position = Trail_Position.global_position
	parent.get_child(get_index() - 1).add_sibling(water)
	
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		audio_stream_player_2d_hurt.play()
		self.hp -= dam #subtracte hp based on damage
		frameFreeze(0.1, 0.4) #free frame (time scale, duration)
		
		#player damaged here
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
			#print("player hit")
		else:
			state_machine.set_state(state_machine.states.dead)
			audio_stream_player_2d_dead.play()
			velocity += dir * force * 2
			
		#if Global.hunger == 0:
			#state_machine.set_state(state_machine.states.dead)
			#audio_stream_player_2d_dead.play()
			#velocity += dir * force * 2

func frameFreeze(timeScale, duration): #call when you want to freeze "time"
	Engine.time_scale = timeScale
	await(get_tree().create_timer(duration * timeScale).timeout)
	Engine.time_scale = 1.0
	
#called every time we modify the value of the hp variable
func set_hp(new_hp: int) -> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)

func _on_timer_timeout():
	Global.hunger -= 1
	
	if Global.hunger == 0:
		state_machine.set_state(state_machine.states.dead)

func _eat_fish():
	if Input.is_action_just_pressed("eat"):
		if Global.fish > 0:
			Global.fish -= 1 #remove fish 
			Global.hunger += 5 #add food to hunger
			audio_stream_player_2d_eat.play()
			anim_sprite.play("eat")
			await anim_sprite.animation_finished
	
