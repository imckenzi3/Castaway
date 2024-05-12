extends CharacterBody2D

@export var speed = 100
@export var accel = 10

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

func _physics_process(_delta: float) -> void:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		
		move_and_slide()
		
#func _process(_delta: float) -> void:
