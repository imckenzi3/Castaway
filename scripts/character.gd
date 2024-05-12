extends CharacterBody2D
class_name Character

#Hit effect
#const HIT_EFFECT_SCENE: PackedScene = preload("res://characters/player/hitEffect.tscn")

#player movement
const FRICTION: float = 0.15 
@export var acc: int = 40 #acceleration
@export var max_speed: int = 100 #max_speed

var move_direction: Vector2 = Vector2.ZERO
var veloctiy: Vector2 = Vector2.ZERO

#jump - no longer needed at this moment
const speed = 45
#const jump_power = -650 

const friction = 60 #friction

#jumping
const max_jumps = 2
var current_jumps = 1

#stateMachine
@onready var state_machine: Node = get_node("FiniteStateMachine")

##health
#@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

#animated_Sprite
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

#flying
@export var flying: bool = false

#damage numbers
#@onready var damage_number_origin: Node2D = get_node("DamageNumbersOrigin")

#death particles in testing
@export var deathParticle: PackedScene

#loop over and over
func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
#player movement
func move() -> void:
	move_direction = move_direction.normalized()
	velocity += move_direction * acc
	velocity = velocity.limit_length(max_speed)
	
#Taking Damage
#func take_damage(dam: int, dir: Vector2, force: int) -> void:
	#if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		#
		#_spawn_hit_effect() #hit effect
		#self.hp -= dam #subtracte hp based on damage
		#
		##save hp for next level
		#if name == "player":
				#SavedData.hp = hp
				#if hp == 0:
					#SceneTransistor.start_transition_to("res://scenes/game.tscn")
					#SavedData.reset_data()
					#
		#DamageNumbers.display_number(dam, damage_number_origin.global_position) #display damage numbers
		##var is_critical self.crit_chance > randf()
		#
		##if after taking damage the hp is greater than 0
		##set the state to hurt and apply a normal knockback (theres no knockbacks in darksouls) are there?
		##!!!knock back doesnt work - fix later if we want it
		#
		##player damaged here
		#if hp > 0:
			#state_machine.set_state(state_machine.states.hurt)
			#velocity += dir * force
			##print("player hit")
		#else:
			#state_machine.set_state(state_machine.states.dead)
			#velocity += dir * force * 2
			#
			##player death here
			##print("player died")
			##Kill()
		
##called every time we modify the value of the hp variable
#func set_hp(new_hp: int) -> void:
	#hp = new_hp
	#emit_signal("hp_changed", new_hp)
#
#func _spawn_hit_effect() -> void:
	#var hit_effetct: Sprite2D = HIT_EFFECT_SCENE.instantiate()
	#add_child(hit_effetct)
	
func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)
	
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)

#free frame effec
func frameFreeze(timeScale, duration): #call when you want to freeze "time"
	Engine.time_scale = timeScale
	await(get_tree().create_timer(duration * timeScale).timeout)
	Engine.time_scale = 1.0
	
