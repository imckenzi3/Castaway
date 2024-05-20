extends Button

func _on_pressed():
	if Global.fish != 0:
		Global.fish = 0
		
	if Global.hunger != 25:
		Global.hunger = 25
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")
