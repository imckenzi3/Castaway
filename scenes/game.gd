extends Node2D

var fish = preload("res://scenes/fish.tscn")
var shark = preload("res://scenes/shark.tscn")

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

func _on_timer_2_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Player/SharkPath2D/PathFollow2D.progress = rng.randi_range(0,3664)
	var instance2 = shark.instantiate()
	instance2.global_position = $Player/SharkPath2D/PathFollow2D/Marker2D.global_position
	add_child(instance2)
