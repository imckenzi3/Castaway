extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	_add_state("eat")
	
func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if state == states.idle or state == states.move:
		parent.move_and_slide()
		
	if state == states.move:
		parent.spawn_water()

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
			animation_player2.play("idle") #shadow sprite
		states.move:
			animation_player.play("move")
			animation_player2.play("move") #shadow sprite
			#parent.spawn_water()
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
		states.eat:
			animation_player.play("eat")

