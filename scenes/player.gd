extends CharacterBody2D

@export var speed = 100
@export var accel = 10

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var Trail_Position: Node2D = get_node("TrailPosition")
const WATER_TRAIL_SCENE: PackedScene = preload("res://scenes/water_trail.tscn")
@onready var parent: Node2D = get_parent()

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
