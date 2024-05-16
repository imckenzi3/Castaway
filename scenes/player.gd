extends CharacterBody2D

@export var speed = 100
@export var accel = 10

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var Trail_Position: Node2D = get_node("TrailPosition")
const WATER_TRAIL_SCENE: PackedScene = preload("res://scenes/water_trail.tscn")
@onready var parent: Node2D = get_parent()
@onready var state_machine: Node = get_node("FiniteStateMachine")

@export var hp: int = 2: set = set_hp
signal hp_changed(new_hp)

func _physics_process(_delta: float) -> void:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		velocity.x = move_toward(velocity.x, speed * direction.x, accel) 
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		
		if velocity.x > 0 and anim_sprite.flip_h:
			anim_sprite.flip_h = false
		elif velocity.x < 0 and not anim_sprite.flip_h:
			anim_sprite.flip_h = true
			
		move_and_slide()

func spawn_water() ->void:
	var water: Sprite2D = WATER_TRAIL_SCENE.instantiate()
	water.position = Trail_Position.global_position
	parent.get_child(get_index() - 1).add_sibling(water)
	
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		
		#_spawn_hit_effect() #hit effect
		self.hp -= dam #subtracte hp based on damage
		frameFreeze(0.1, 0.4) #free frame (time scale, duration)
		#save hp for next level
		#if name == "player":
				#SavedData.hp = hp
				#if hp == 0:
					#SceneTransistor.start_transition_to("res://scenes/game.tscn")
					#SavedData.reset_data()
					
		#DamageNumbers.display_number(dam, damage_number_origin.global_position) #display damage numbers
	
		#player damaged here
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
			#print("player hit")
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2
			
			#player death here
			#print("player died")
			#Kill()

func frameFreeze(timeScale, duration): #call when you want to freeze "time"
	Engine.time_scale = timeScale
	await(get_tree().create_timer(duration * timeScale).timeout)
	Engine.time_scale = 1.0
	
#called every time we modify the value of the hp variable
func set_hp(new_hp: int) -> void:
	hp = new_hp
	emit_signal("hp_changed", new_hp)
	
