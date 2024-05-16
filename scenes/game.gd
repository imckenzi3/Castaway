extends Node2D

var fish = preload("res://scenes/fish.tscn")

func _init() -> void:
	randomize()

#spawns random fish
func _on_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	$Player/Path2D/PathFollow2D.progress = rng.randi_range(0,3664)
	var instance = fish.instantiate()
	
	instance.global_position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	add_child(instance)

